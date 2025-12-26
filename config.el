;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; this is useful for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 18 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 18)
      doom-symbol-font (font-spec :family "FiraCode Nerd Font")
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 24))

(defvar serif-preserve-default-list nil
  "A list holding the faces that preserve the default family and
  height when TOGGLE-SERIF is used.")
(setq serif-preserve-default-list
      '(;; LaTeX markup
        font-latex-math-face
        font-latex-sedate-face
        font-latex-warning-face
        ;; org markup
        org-latex-and-related
        org-meta-line
        org-verbatim
        org-block-begin-line
        ;; syntax highlighting using font-lock
        font-lock-builtin-face
        font-lock-comment-delimiter-face
        font-lock-comment-face
        font-lock-constant-face
        font-lock-doc-face
        font-lock-function-name-face
        font-lock-keyword-face
        font-lock-negation-char-face
        font-lock-preprocessor-face
        font-lock-regexp-grouping-backslash
        font-lock-regexp-grouping-construct
        font-lock-string-face
        font-lock-type-face
        font-lock-variable-name-face
        font-lock-warning-face
        line-number))

(defun toggle-serif ()
  "Change the default face of the current buffer to use a serif family."
  (interactive)
  (when (display-graphic-p)  ;; this is only for graphical emacs
    ;; the serif font familiy and height, save the default attributes
    (let ((serif-fam "Liberation Serif")
          (serif-height 170)
          (default-fam (face-attribute 'default :family))
          (default-height (face-attribute 'default :height)))
      (if (not (bound-and-true-p default-cookie))
          (progn (make-local-variable 'default-cookie)
                 (make-local-variable 'preserve-default-cookies-list)
                 (setq preserve-default-cookies-list nil)
                 ;; remap default face to serif
                 (setq default-cookie
                       (face-remap-add-relative
                        'default :family serif-fam :height serif-height))
                 ;; keep previously defined monospace fonts the same
                 (dolist (face serif-preserve-default-list)
                   (add-to-list 'preserve-default-cookies-list
                                (face-remap-add-relative
                                 face :family default-fam :height default-height)))
                 (message "Turned on serif writing font."))
        ;; undo changes
        (progn (face-remap-remove-relative default-cookie)
               (dolist (cookie preserve-default-cookies-list)
                 (face-remap-remove-relative cookie))
               (setq default-cookie nil)
               (setq preserve-default-cookies-list nil)
               (message "Restored default fonts."))))))

(add-hook 'org-mode-hook 'toggle-serif)
(add-hook 'Info-mode-hook 'toggle-serif)
(add-hook 'Man-mode-hook 'toggle-serif)
(add-hook 'devdocs-mode-hook 'toggle-serif)

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-gruvbox)
;; (setq doom-theme 'doom-solarized-light)
(setq doom-theme 'modus-operandi-tinted)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory') - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol and press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how it is used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; Print everything in vterm as soon as it gets out of the terminal sessions
(setq vterm-timer-delay 0.01)

;; Open Dired for the current file’s folder with the `-` key
(after! doom
  (map! :map (prog-mode-map markdown-mode-map text-mode-map)
        :n "-" #'dired-jump))

;; Browse code at point on corresponding forge (GitHub/Gitlab/etc)
(after! doom
  (require 'browse-at-remote))

;; -------------------------------------------------
;; Resize windows with Ctrl‑←/↑/→/↓
;; -------------------------------------------------
;;   C-←  → shrink window horizontally
;;   C-→  → enlarge window horizontally
;;   C-↑  → shrink window vertically
;;   C-↓  → enlarge window vertically
;;
;; The bindings are defined for:
;;   • Evil normal & visual states (`:n` and `:v`)
;;   • Emacs insert state (`:i`) – useful if you ever turn off Evil
;;   • The global map (so they also work in non‑Evil buffers)
;;
(after! evil
  ;; vim-matchit port to emacs
  (require 'evil-matchit)
  (global-evil-matchit-mode 1)
  (map! :leader
        ;; you can also expose them under a leader key if you like:
        :desc "Resize window left  " "C-h" #'shrink-window-horizontally
        :desc "Resize window right " "C-l" #'enlarge-window-horizontally
        :desc "Resize window up    " "C-k" #'shrink-window
        :desc "Resize window down  " "C-j" #'enlarge-window)

  ;; Direct Ctrl‑arrow bindings (global, works in all states)
  (map! :n "C-<left>"  #'shrink-window-horizontally
        :n "C-<right>" #'enlarge-window-horizontally
        :n "C-<up>"    #'shrink-window
        :n "C-<down>"  #'enlarge-window

        :v "C-<left>"  #'shrink-window-horizontally
        :v "C-<right>" #'enlarge-window-horizontally
        :v "C-<up>"    #'shrink-window
        :v "C-<down>"  #'enlarge-window

        :i "C-<left>"  #'shrink-window-horizontally
        :i "C-<right>" #'enlarge-window-horizontally
        :i "C-<up>"    #'shrink-window
        :i "C-<down>"  #'enlarge-window))

;; -------------------------------------------------
;; Expand / contract visual selection by Tree‑sitter nodes
;; -------------------------------------------------
(use-package! expreg :ensure t)

(after! doom
  (require 'expreg)
  (map!
   (:map 'override
    :v "v" #'expreg-expand
    :v "V" #'expreg-contract)))

;; (map!
;;  (:map 'override
;;   :v "v" #'er/expand-region
;;   :v "V" #'er/contract-region))


(use-package! org-download :defer t)
;; Paste images directly in `org buffers
(after! '(org dired)
  (require 'org-download)
  ;; Drag-and-drop to `dired`
  (add-hook 'dired-mode-hook 'org-download-enable))

(defun my/gptel-image-download-setup ()
  (require 'org-download)
  (when (derived-mode-p 'org-mode)
    (with-eval-after-load 'org-download
      (setq-local org-download-image-dir
                  (file-name-as-directory (concat (file-name-as-directory temporary-file-directory) "gptel")))
      (setq-local org-download-heading-lvl nil)
      )
    )
  )
(add-hook 'gptel-mode-hook #'my/gptel-image-download-setup)

;; ---------------------------------------------------------------------------
;; Focus the newly‑created window after an Evil split / vsplit
;; ---------------------------------------------------------------------------

(defun my/evil-focus-new-window (orig-fun &rest args)
  "Run ORIG-FUN (a split command) and then select the window that was just created.
Works for `evil-window-split' and `evil-window-vsplit'."
  (let ((old-win (selected-window)))   ; window we are in before the split
    (apply orig-fun args)               ; do the actual split
    ;; `next-window' walks the window list in the same order that `evil-window-split'
    ;; and `evil-window-vsplit' add the new window, so the next window is the one we
    ;; just created.
    (when (window-live-p (next-window old-win))
      (select-window (next-window old-win)))))

;; Advise the two split commands
(advice-add #'evil-window-split  :around #'my/evil-focus-new-window)
(advice-add #'evil-window-vsplit :around #'my/evil-focus-new-window)

;; Optional: if you also use the “split” commands from the `window` package
;; (e.g. `split-window-below' or `split-window-right'), you can reuse the same
;; helper:
(advice-add #'split-window-below :around #'my/evil-focus-new-window)
(advice-add #'split-window-right :around #'my/evil-focus-new-window)

;; This will enable gravatars when viewing commits. The service used by default is Libravatar.
(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

;; By default, changes are highlighted line-wise for all but the selected hunk. This has performance reasons. You can enable character-wise highlights for all visible hunks with:
(after! magit
  (setq magit-diff-refine-hunk 'all)
  (remove-hook 'magit-refs-sections-hook 'magit-insert-tags)
  (remove-hook 'server-switch-hook 'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff))

;; Navigate across windows with avy
(setq! avy-all-windows 't)

;; Highlight the current context using indent-bars
(after! indent-bars
  (setq! indent-bars-color '(font-lock-comment-face :face-bg nil :blend 0.225)
         indent-bars-starting-column 'nil
         indent-bars-zigzag 0.02
         indent-bars-highlight-current-depth '(:face normal :width 0.2 :blend 1.5)))

(setq! auth-sources '("~/.authinfo"))

;; Configure folders used for projects
(setq! projectile-project-search-path '("~/apps/finetune/" "~/apps/clipbook/" "~/apps/"))

(after! magit
  (setq magit-delta-default-dark-theme "Monokai Extended"
        magit-delta-default-light-theme "GitHub"
        magit-delta-hide-plus-minus-markers 't)
  (magit-delta-mode))


;; Easy transpose lines
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(control shift down)]  'move-line-down)
(global-set-key [(control shift up)]  'move-line-up)

;; Early on enable breadcrumbs for lsp
(use-package! lsp-mode
  :init
  (setq lsp-headerline-breadcrumb-icons-enable t
        lsp-headerline-breadcrumb-icons-enable t
        lsp-headerline-breadcrumb-segments '(symbols)))

;; Configure models and prompts for `gptel'
(use-package! gptel
  :config
  (setq! gptel-api-key (lambda () (getenv "OPENAI_API_KEY"))
         ;; gptel-model   'gpt-oss-120b
         gptel-expert-commands t
         gptel-default-mode 'org-mode
         gptel-model 'claude-opus-4-5-20251101
         gptel-backend
           (gptel-make-anthropic "Claude"
             :stream t :key (lambda () (getenv "ANTHROPIC_API_KEY")))
         ;; gptel-backend
         ;; (gptel-make-openai "Cerebras"
         ;;   :host "api.cerebras.ai"
         ;;   :endpoint "/v1/chat/completions"
         ;;   :stream nil
         ;;   :key (lambda () (getenv "CEREBRAS_API_KEY"))
         ;;   :models '(gpt-oss-120b
         ;;             qwen-3-coder-480b
         ;;             llama3.1-70b
         ;;             llama3.1-8b)))
))

(gptel-make-gemini "Gemini" :key (lambda () (getenv "GEMINI_API_KEY")) :stream t)
;; (gptel-make-anthropic "Anthropic" :key (lambda () (getenv "ANTHROPIC_API_KEY")) :stream t)

(use-package! templatel :defer t)
;; Poet files should be opened as yaml
(add-to-list 'auto-mode-alist '("\\.poet\\'" . yaml-mode))

;; Implement prompt templates in their own files
(after! gptel
  (setq! gptel-prompts-directory (concat doom-user-dir "gptel-prompts"))
  (require 'gptel-integrations)
  (require 'templatel)
  (require 'gptel-prompts)
  (gptel-prompts-update)
  ;; Ensure prompts are updated if prompt files change
  (gptel-prompts-add-update-watchers)
  (setq! gptel--system-message (alist-get 'base gptel-directives)))


;; ;; 1. The buffer name that Aideremacs creates.
;; (defvar aidermacs-buffer-name "*aidermacs*")
;; ;; 2. Register a Doom popup rule.
;; (set-popup-rule! aidermacs-buffer-name        ; match the buffer name
;;                 :side 'bottom                 ; bottom edge of the frame
;;                 :size 0.25                    ; ~25 % of the frame height (adjust as you like)
;;                 :slot -1)                     ; ensures it’s the *last* window on that side

;; Save last location when entering a file
(save-place-mode 1)

(setq! web-mode-enable-current-element-highlight t)

;; Open projectile dispatcher when opening a project
(after! projectile
  (setq! projectile-switch-project-action #'projectile-dired))


(after! lsp-mode
  ;; Re-enable lsp-mode's built-in headerline/breadcrumbs,
  ;; which Doom Emacs disables by default.
  (setq lsp-headerline-mode t
        lsp-headerline-breadcrumb-enable t
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        lsp-ui-sideline-enable nil))

(add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)

(add-to-list 'lsp-language-id-configuration '(".*\\.scss$" . "css"))
;; Load tailwindcss LSP
(use-package! lsp-tailwindcss
  :after lsp-mode
  :init
  (setq lsp-tailwindcss-add-on-mode nil))

;; Only enable ruby-lsp
(add-to-list 'lsp-disabled-clients 'rubocop-ls)

;; Tell lsp‑mode that a `web-mode` buffer representing an .html.erb
(add-to-list 'lsp-language-id-configuration '(".*\\.html\\.erb$" . "html"))

;; Add useful stuff to `rotate-text' library
;; https://github.com/otavioschwanck/doom-emacs-on-rails/blob/master/modules/ruby.el
(after! rotate-text
  (add-to-list 'rotate-text-words '("valid" "invalid"))
  (add-to-list 'rotate-text-words '("context" "describe"))
  (add-to-list 'rotate-text-symbols '("be_valid" "be_invalid"))
  (add-to-list 'rotate-text-symbols '("valid?" "invalid?"))
  (add-to-list 'rotate-text-symbols '("present?" "blank?" "nil?"))
  (add-to-list 'rotate-text-symbols '("belongs_to" "has_many" "has_one"))
  (add-to-list 'rotate-text-symbols '("if" "unless"))
  (add-to-list 'rotate-text-symbols '("greater_than" "greater_than_or_equal_to" "equal_to" "less_than" "less_than_or_equal_to" "other_than" "odd" "even"))
  (add-to-list 'rotate-text-symbols '("to" "not_to")))


;; Make the active mode‑line stand out
(after! doom-modeline          ; runs after the modeline package is loaded
  (set-face-attribute 'mode-line nil
                      :background "#ff5f00"   ; a vivid orange, change to any colour you like
                      :foreground "#ffffff"
                      :box nil))              ; optional: remove the thin box

;; Add `ace-window` command to embark
(eval-when-compile
  (defmacro my/embark-ace-action (fn)
    `(defun ,(intern (concat "my/embark-ace-" (symbol-name fn))) ()
       (interactive)
       (with-demoted-errors "%s"
         (require 'ace-window)
         (let ((aw-dispatch-always t))
           (aw-switch-to-window (aw-select nil))
           (call-interactively (symbol-function ',fn)))))))

;; (define-key embark-file-map                (kbd "o") (my/embark-ace-action find-file))
;; (define-key embark-projectile-file-map     (kbd "o") (my/embark-ace-action projectile-find-file))
;; (define-key embark-buffer-map              (kbd "o") (my/embark-ace-action switch-to-buffer))
;; (define-key embark-bookmark-map            (kbd "o") (my/embark-ace-action bookmark-jump))
;; (define-key embark-search-project          (kbd "o") (my/embark-ace-action +default/search-project))

;; Bind devdocs-looup to `<leader> h s` since the default binding is not useful
(map! :leader
      (:prefix ("h" . "help")
       :desc "DevDocs lookup"
       "s" #'devdocs-lookup))


;; Some goodies for tree-sitter sexp movements

;;;###autoload
(defun +tree-sitter-get-textobj (group &optional query)
  "A wrapper around `evil-textobj-tree-sitter-get-textobj' to
prevent eager expansion."
  (eval `(evil-textobj-tree-sitter-get-textobj ,group ,query)))

;;;###autoload
(defun +tree-sitter-goto-textobj (group &optional previous end query)
  "Thin wrapper that returns the symbol of a named function, used in keybindings."
  (let ((sym (intern (format "+goto%s%s-%s" (if previous "-previous" "") (if end "-end" "") group))))
    (fset sym (lambda ()
                (interactive)
                (evil-textobj-tree-sitter-goto-textobj group previous end query)))
    sym))

(use-package! evil-textobj-tree-sitter
  :defer t
  :init (after! treesit (require 'evil-textobj-tree-sitter))
  :after-call doom-first-input-hook
  :config
  (defvar +tree-sitter-inner-text-objects-map (make-sparse-keymap))
  (defvar +tree-sitter-outer-text-objects-map (make-sparse-keymap))
  (defvar +tree-sitter-goto-previous-map (make-sparse-keymap))
  (defvar +tree-sitter-goto-next-map (make-sparse-keymap))

  (evil-define-key '(visual operator) 'tree-sitter-mode
    "i" +tree-sitter-inner-text-objects-map
    "a" +tree-sitter-outer-text-objects-map)
  (evil-define-key 'normal 'tree-sitter-mode
    "[g" +tree-sitter-goto-previous-map
    "]g" +tree-sitter-goto-next-map)

  (map! (:map +tree-sitter-inner-text-objects-map
         "A" (+tree-sitter-get-textobj '("parameter.inner" "call.inner"))
         "f" (+tree-sitter-get-textobj "function.inner")
         "F" (+tree-sitter-get-textobj "call.inner")
         "C" (+tree-sitter-get-textobj "class.inner")
         "v" (+tree-sitter-get-textobj "conditional.inner")
         "l" (+tree-sitter-get-textobj "loop.inner"))
        (:map +tree-sitter-outer-text-objects-map
         "A" (+tree-sitter-get-textobj '("parameter.outer" "call.outer"))
         "f" (+tree-sitter-get-textobj "function.outer")
         "F" (+tree-sitter-get-textobj "call.outer")
         "C" (+tree-sitter-get-textobj "class.outer")
         "c" (+tree-sitter-get-textobj "comment.outer")
         "v" (+tree-sitter-get-textobj "conditional.outer")
         "l" (+tree-sitter-get-textobj "loop.outer"))

        (:map +tree-sitter-goto-previous-map
         "a" (+tree-sitter-goto-textobj "parameter.outer" t)
         "f" (+tree-sitter-goto-textobj "function.outer" t)
         "F" (+tree-sitter-goto-textobj "call.outer" t)
         "C" (+tree-sitter-goto-textobj "class.outer" t)
         "c" (+tree-sitter-goto-textobj "comment.outer" t)
         "v" (+tree-sitter-goto-textobj "conditional.outer" t)
         "l" (+tree-sitter-goto-textobj "loop.outer" t))
        (:map +tree-sitter-goto-next-map
         "a" (+tree-sitter-goto-textobj "parameter.outer")
         "f" (+tree-sitter-goto-textobj "function.outer")
         "F" (+tree-sitter-goto-textobj "call.outer")
         "C" (+tree-sitter-goto-textobj "class.outer")
         "c" (+tree-sitter-goto-textobj "comment.outer")
         "v" (+tree-sitter-goto-textobj "conditional.outer")
         "l" (+tree-sitter-goto-textobj "loop.outer")))

  (after! which-key
    (setq which-key-allow-multiple-replacements t)
    (pushnew!
     which-key-replacement-alist
     '(("" . "\\`+?evil-textobj-tree-sitter-function--\\(.*\\)\\(?:.inner\\|.outer\\)") . (nil . "\\1")))))

;; Claude Code IDE
(use-package! claude-code-ide
  :config
  ;; Set window position and height
  (setq claude-code-ide-window-side 'bottom
        claude-code-ide-window-height 30)

  ;; Enable Emacs MCP tools
  (claude-code-ide-emacs-tools-setup))

;; Doom leader key binding
(map! :leader
      (:prefix ("o" . "open")
       :desc "Claude Code" "l c" #'claude-code-ide-menu))


;; -------------------------------------------------------------------
;;  Yank (copy) the current Git branch name
;; -------------------------------------------------------------------
;; Place this anywhere after `magit' has been loaded (e.g. at the end
;; of your config file or inside an `after! magit' block).

(after! magit
  (defun my/copy-git-branch-name ()
    "Copy the name of the current Git branch to the kill‑ring.
If the current buffer is not visiting a file inside a Git repository,
display a helpful message instead.

The command works with both Magit and plain VC‑Git, so it is safe even
if Magit is disabled."
    (interactive)
    (let* ((git-root (magit-toplevel))          ; directory of the repo or nil
           (branch
            (cond
             ;; Magit knows the branch already
             (git-root
              (magit-get-current-branch))
             ;; Fallback to VC – works only when VC is enabled for git
             ((and buffer-file-name
                   (vc-git-root (buffer-file-name)))
              (car (vc-git-branches)))
             (t nil))))
      (if (and branch (stringp branch) (not (string-empty-p branch)))
          (progn
            (kill-new branch)
            (message "Copied Git branch: %s" branch))
        (message "No Git branch found for this buffer"))))

  ;; Optional keybinding (feel free to change the prefix)
  (map! :leader
        :desc "Copy current Git branch" "g y" #'my/copy-git-branch-name))

;; -------------------------------------------------------------------
;;  Auto‑populate Forge PR title with the last commit subject
;; -------------------------------------------------------------------
(after! forge
  ;; ---------------------------------------------------------------
  ;; Helper: obtain the subject line of the most recent commit.
  ;; ---------------------------------------------------------------
  (defun my/forge--last-commit-subject ()
    "Return the *subject* (first line) of the most recent commit on the
current branch, or nil if it cannot be determined.

The function tries, in order:

1. `magit-get-last-message' (Magit helper).
2. A raw `git log` call (fallback when Magit is not loaded or fails)."
    (or ;; 1. Use the Magit helper if it exists and we are in a repo
        (when (fboundp 'magit-get-last-message)
          (let ((msg (magit-get-last-message)))
            (when (and msg (stringp msg))
              (car (split-string msg "\n")))))
        ;; 2. Fallback: run a short Git command ourselves
        (let* ((git-root (magit-toplevel))   ; nil if not a repo
               (default-directory (or git-root default-directory)))
          (when git-root
            (let ((raw (string-trim
                        (shell-command-to-string "git log -1 --pretty=%s"))))
              (unless (string-empty-p raw) raw))))))

  ;; ---------------------------------------------------------------
  ;; Advice that runs *around* `forge-create-pullreq'.
  ;; ---------------------------------------------------------------
  (defun my/forge--populate-pr-title (orig-fun &rest args)
    "When creating a new Forge PR, pre‑fill the title with the last commit
subject.

ORIG-FUN is the original `forge-create-pullreq' command."
    (let ((title (my/forge--last-commit-subject))) ; may be nil
      ;; Call the original command – it creates the PR buffer and switches to it.
      (apply orig-fun args)
      ;; If we managed to obtain a title *and* we are really in a Forge PR
      ;; buffer, replace the first line with that title.
      (when (and title
                 (derived-mode-p 'forge-create-pullreq-mode))
        (save-excursion
          (goto-char (point-min))                ; first line = title
          (delete-region (line-beginning-position) (line-end-position))
          (insert title))))
    ;; Return whatever the original command returned (usually the buffer).
    nil)

  ;; Install the advice
  (advice-add #'forge-create-pullreq :around #'my/forge--populate-pr-title))
