# ELISA Setup Plan

Local-first RAG over Emacs/Doom manuals using EmbeddingGemma. Authored against the current `init.el` / `config.el` / `packages.el`.

## 1. Hardware reality (from `llmfit system`)

| Resource | Value | Implication |
|---|---|---|
| CPU | i7-11800H (16 cores) | Fine for CPU inference of small models |
| RAM | 47 GB total / ~34 GB free | Plenty for embedding + small chat |
| GPU 1 | NVIDIA RTX A2000 Laptop, **4 GB VRAM**, CUDA | Tight. One small model fits comfortably; two are a squeeze |
| GPU 2 | AMD (ROCm) | Ignore; CUDA is the cleaner path |

**Verdict:** EmbeddingGemma 300M @ Q8 (~330 MB VRAM) fits trivially. Running a *chat* model on the same GPU at the same time is risky — at 4 GB VRAM you'd be juggling.

## 2. Architecture choice

Two viable routes. Pick **Route A** unless you specifically want offline answers.

### Route A — recommended: local embeddings + cloud chat
- **Embeddings:** local `llama-server` running EmbeddingGemma 300M. ~330 MB VRAM, always-on, fully private corpus.
- **Chat synthesis:** your existing `agent-shell` Anthropic Claude auth (no new API key needed).
- **Pros:** zero VRAM pressure, top-quality answers, simple ops.
- **Cons:** chat synthesis sends the retrieved chunks (your manual quotes + question) to Anthropic.

### Route B — fully local
- **Embeddings:** same EmbeddingGemma local server.
- **Chat:** a *separate* `llama-server` instance with a small chat model.
- Candidate chat models for 4 GB VRAM (must fit alongside embedding model = ~3.5 GB budget):
  - `unsloth/gemma-3-1b-it-GGUF` (Q4_K_M, ~700 MB) — light, decent quality
  - Gemma 3 1B at Q5/Q8 if you push VRAM
  - Qwen2.5-3B-Instruct GGUF (Q4_K_M, ~2 GB) — best quality that still fits, no headroom for big context
- **Pros:** 100% offline, no traffic leaves the laptop.
- **Cons:** noticeably weaker synthesis than Claude; you'll juggle VRAM if you also run other CUDA workloads.

> **Plan below targets Route A.** Switching to Route B is a one-line change to `elisa-chat-provider`.

## 3. Install steps

### 3.1 llama.cpp
Pick one:
```bash
# Build from source (recommended, gets CUDA support):
git clone https://github.com/ggml-org/llama.cpp ~/src/llama.cpp
cd ~/src/llama.cpp && cmake -B build -DGGML_CUDA=ON && cmake --build build -j
# binary lands at ~/src/llama.cpp/build/bin/llama-server
```
Or `brew install llama.cpp` if Homebrew is set up. The Fedora dnf package is generally too old.

### 3.2 EmbeddingGemma GGUF
```bash
mkdir -p ~/models
# Pick ONE of these (Q8_0 preferred for quality, ~330 MB):
hf download google/embeddinggemma-300m-GGUF \
  embeddinggemma-300M-Q8_0.gguf --local-dir ~/models
# Alternative if VRAM is tighter (~200 MB):
# hf download google/embeddinggemma-300m-qat-q4_0-gguf ... --local-dir ~/models
```
> Confirm exact filename on the HF repo at download time — Google occasionally renames variants.

### 3.3 systemd --user unit
File: `~/.config/systemd/user/llama-embed.service`
```ini
[Unit]
Description=llama.cpp embedding server (EmbeddingGemma)
After=default.target

[Service]
ExecStart=/home/paulh/src/llama.cpp/build/bin/llama-server \
  -m /home/paulh/models/embeddinggemma-300M-Q8_0.gguf \
  --embedding \
  --pooling mean \
  --port 8080 \
  --host 127.0.0.1
Restart=on-failure

[Install]
WantedBy=default.target
```
Enable:
```bash
systemctl --user daemon-reload
systemctl --user enable --now llama-embed.service
curl -s http://127.0.0.1:8080/v1/models   # sanity check
```

### 3.4 Verify the embedding endpoint
```bash
curl -s http://127.0.0.1:8080/v1/embeddings \
  -H 'Content-Type: application/json' \
  -d '{"model":"embeddinggemma","input":"hello"}' | head -c 200
```
A vector should come back. If not, fix this before touching Doom.

## 4. Doom changes

### 4.1 `packages.el` — add
```elisp
(package! elisa)
(package! llm)
```
Then `doom sync`.

### 4.2 `config.el` — add at the bottom
```elisp
;; -----------------------------------------------------------------------------
;; ELISA: RAG over Emacs info manuals + project notes
;; -----------------------------------------------------------------------------
(use-package! elisa
  :defer t
  :init
  (map! :leader
        (:prefix ("o l" . "llm")
         :desc "ELISA chat"        "e" #'elisa-chat
         :desc "ELISA web search"  "w" #'elisa-web-search))
  :config
  (require 'llm-openai)

  ;; Local EmbeddingGemma via llama-server (Route A).
  (setopt elisa-embeddings-provider
          (make-llm-openai-compatible
           :url "http://127.0.0.1:8080/v1/"
           :embedding-model "embeddinggemma"))

  ;; Chat synthesis through Anthropic (reuse agent-shell's stored creds path,
  ;; or set ANTHROPIC_API_KEY in ~/.authinfo / env).
  (require 'llm-claude)
  (setopt elisa-chat-provider
          (make-llm-claude
           :chat-model "claude-sonnet-4-6"
           :key (auth-source-pick-first-password :host "api.anthropic.com")))

  ;; Optional: keep elisa's index inside the user emacs dir so it survives
  ;; `doom clean`.
  (setopt elisa-prompt-rewriting-enabled nil))   ; one round-trip is enough at first
```

### 4.3 Update CLAUDE.md
Replace the `## AI Configuration` block to mention ELISA alongside `agent-shell`.

## 5. First-run usage

```
M-x elisa-async-parse-info-manuals     ; seed the manual collection (one-time, ~minutes)
M-x elisa-chat                         ; ask: "how do I configure forge tokens?"
M-x elisa-async-parse-directory        ; index ~/org/  if you want your notes in scope
M-x elisa-disable-collection           ; toggle collections per query
```

Bindings added above: `<leader> o l e` (chat), `<leader> o l w` (web search).

## 6. Rollback / cost-control levers

- Stop the embed server: `systemctl --user stop llama-embed`.
- Disable a collection without rebuilding: `elisa-disable-collection`.
- Switch chat to local: change `elisa-chat-provider` to a second `make-llm-openai-compatible` pointing at another `llama-server` instance on a different port.
- Re-index after editing source files: `elisa-async-recalculate-embeddings`.

## 7. Open questions to decide before running

1. Quantization: **Q8_0** (better recall, 330 MB) vs **QAT Q4_0** (200 MB, slight quality hit). Recommend Q8 — VRAM is not the bottleneck for embeddings.
2. Which collections to seed first? Suggest: Emacs core info + Magit + Org + Doom modules dir (`~/.config/emacs/modules`).
3. Reranker: ELISA supports an optional reranker model for better retrieval. Skip until baseline feels insufficient.
