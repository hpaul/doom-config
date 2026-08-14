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
;; JuliaMono
(setq doom-font (font-spec :family "JuliaMono" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JuliaMono" :weight 'light :size 16)
      doom-symbol-font (font-spec :family "JuliaMono" :weight 'light)
      doom-big-font (font-spec :family "JuliaMono" :size 24))

;; ;; JetBrainsMono Nerd Font
;; (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :weight 'light :size 16)
;;       doom-symbol-font (font-spec :family "JetBrainsMono Nerd Font" :weight 'light)
;;       doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 24))

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
    (let ((serif-fam "Atkinson Hyperlegible")
          (serif-height 160)
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
(add-hook 'helpful-mode-hook 'toggle-serif)
(add-hook 'help-mode-hook 'toggle-serif)
(add-hook 'lsp-help-mode-hook 'toggle-serif)

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
  ;; The status header's "next tag" runs `git describe --contains', which walks
  ;; history against every tag: 0.22s of a 0.42s magit-status open here (1093
  ;; tags). Measured with `magit-refresh-verbose'.
  (remove-hook 'magit-status-headers-hook 'magit-insert-tags-header)
  (remove-hook 'server-switch-hook 'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff))

;; Magit's keys are transient *suffixes*, not keymap entries -- `map!' and
;; `define-key' do nothing to them; `transient-suffix-put' is the lever.
;; lazygit muscle memory: `n' creates a branch AND switches to it, and `r'
;; rebases onto another branch. Magit's defaults are `c' and `r e'.
;; Order matters: n -> N must happen before c -> n, or the keys collide.
(after! magit
  (transient-suffix-put 'magit-branch "n" :key "N")   ; create only (was n)
  (transient-suffix-put 'magit-branch "c" :key "n")   ; create + checkout
  (transient-suffix-put 'magit-rebase "e" :key "r"))  ; r r = rebase elsewhere

;; `y s' (magit-copy-section-value) resolves a branch section to its hash --
;; magit-extras.el does (setq value (magit-rev-parse ... value)) and only keeps
;; the ref name behind a prefix arg. This copies the name directly.
(defun my/magit-copy-ref-name ()
  "Copy the reference name of the branch or tag at point, not its hash."
  (interactive)
  (let ((section (magit-current-section)))
    (if (magit-section-match '(branch tag) section)
        (kill-new (message "%s" (oref section value)))
      (user-error "No branch or tag at point"))))

(after! magit
  (evil-define-key 'normal magit-mode-map (kbd "y n") #'my/magit-copy-ref-name))

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
(setq! projectile-project-search-path '("~/apps/finetune/" "~/apps/clipbook/" "~/apps/sogood/" "~/apps/"))

(after! magit
  ;; Difftastic
  (use-package difftastic-bindings
    :ensure difftastic ;; or nil if you prefer manual installation
    :config (difftastic-bindings-mode)))

(use-package! drag-stuff
    :defer t
    :init
    (map! "<M-up>"    #'drag-stuff-up
          "<M-down>"  #'drag-stuff-down
          "<M-left>"  #'drag-stuff-left
          "<M-right>" #'drag-stuff-right))

;; Early on enable breadcrumbs for lsp
(use-package! lsp-mode
  :init
  (setq lsp-headerline-breadcrumb-icons-enable t
        lsp-headerline-breadcrumb-icons-enable t
        lsp-headerline-breadcrumb-segments '(symbols)))



(use-package! templatel :defer t)
;; Poet files should be opened as yaml
(add-to-list 'auto-mode-alist '("\\.poet\\'" . yaml-mode))

;; Save last location when entering a file
(save-place-mode 1)

(setq! web-mode-enable-current-element-highlight t)

;; Open projectile dispatcher when opening a project
(after! projectile
  (setq! projectile-switch-project-action #'projectile-dired))

;; Umbrella workspaces -- one directory holding several sibling git repos
;; (~/apps/sogood) that should behave as a SINGLE project.
;;
;; Projectile already handles this: `projectile-root-marked' runs before
;; `projectile-root-bottom-up', so an empty `.projectile' at the umbrella wins
;; over the nested .git dirs. project.el does not: `project-try-vc' stops at the
;; first .git it meets on the way up. That matters because claude-code-ide.el
;; asks project.el (not projectile) for its working directory, so Claude would
;; otherwise start inside a single sub-repo and lose the cross-repo view.
(defun +project-umbrella-root (dir)
  "Treat the nearest `.projectile'-marked ancestor of DIR as the project root."
  (when-let* ((root (locate-dominating-file dir ".projectile")))
    (cons 'transient (expand-file-name root))))

;; When fd does the indexing it already walks into submodules, so projectile's
;; separate submodule listing only produces duplicate entries (5085 dupes out of
;; 10243 in ~/apps/sogood).
(after! projectile
  (when projectile-fd-executable
    (setq projectile-git-submodule-command nil)))

(after! project
  (add-hook 'project-find-functions #'+project-umbrella-root))


(after! lsp-mode
  ;; Re-enable lsp-mode's built-in headerline/breadcrumbs,
  ;; which Doom Emacs disables by default.
  (setq lsp-headerline-mode t
        lsp-headerline-breadcrumb-enable t
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        lsp-ui-sideline-enable nil
        ;; Never prompt to watch large repos; skip file watchers (always "n").
        lsp-enable-file-watchers nil
        ;; Throttle: debounce didChange/pull-diagnostics bursts (esp. after a
        ;; branch switch, when many buffers change at once).
        lsp-idle-delay 1.0))

;; The vscode-eslint server defaults to `run' = "onType", which re-lints the
;; whole file on every keystroke. With this repo's .eslintrc (import + prettier
;; plugins) that pegs a core permanently. Lint on save instead.
(after! lsp-eslint
  (setq lsp-eslint-run "onSave"))

;; `mode-enabled' checks the moment flycheck-mode turns on, i.e. while the file
;; is still opening -- that first check blocks on the lsp attach (measured:
;; 1.059s cold, 0.000s warm, visiting a file from magit). `idle-buffer-switch'
;; gives the same on-open diagnostics a beat later, without blocking.
(after! flycheck
  (setq flycheck-check-syntax-automatically '(save idle-change idle-buffer-switch)))

;; tsserver has no memory ceiling by default and grows unbounded across long
;; sessions (esp. with many branch switches). Cap it so it recycles instead.
(after! lsp-javascript
  (setq lsp-clients-typescript-max-ts-server-memory 3072))

(add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)

(add-to-list 'lsp-language-id-configuration '(".*\\.scss$" . "css"))

;; Load tailwindcss LSP
(use-package! lsp-tailwindcss
  :after lsp-mode
  :init
  (setq lsp-tailwindcss-add-on-mode t))

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
                      :box nil)              ; optional: remove the thin box

  (setq doom-modeline-percent-position '(-3 "%p")))

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
;; NOTE: do not use `(:prefix ("h" . "help") ...)' here -- the cons form builds
;; a *new* prefix keymap and binds it at `h', clobbering Doom's `help-map'
;; (config/default/+evil-bindings.el:343) and every SPC h helper with it.
(map! :leader
      :desc "DevDocs lookup" "h s" #'devdocs-lookup)


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


(use-package treesit-sexp
  :ensure t
  :config
  (global-treesit-sexp-mode 1))


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
  ;; Auto-pulling forge data on every magit-status fires an async GitHub round
  ;; trip (~0.45s) that refreshes the buffer under you a beat after it opens.
  ;; Pull on demand with `f f' instead.
  ;; (add-hook 'magit-status-mode-hook #'forge-pull)

  (defun my/forge--last-commit-subject ()
    "Return the subject line of the most recent commit on the current branch."
    (when-let ((default-directory (magit-toplevel)))
      (string-trim
       (shell-command-to-string "git log -1 --pretty=%s"))))

  (defun my/forge--populate-pr-title ()
    "Auto-fill PR title with the last commit subject if empty or placeholder."
    (when-let ((title (my/forge--last-commit-subject)))
      (save-excursion
        (goto-char (point-min))
        ;; Replace if the first line is empty or contains only # characters
        (when (looking-at-p "^[[:space:]#]*$")
          (delete-region (line-beginning-position) (line-end-position))
          (insert title)))))

  (add-hook 'forge-create-pullreq-mode-hook #'my/forge--populate-pr-title))


;; -----------------------------------------------------------------------------
;; Claude Code IDE
;; -----------------------------------------------------------------------------
;; Runs the real `claude' CLI in a ghostel popup, and exposes Emacs itself
;; (xref/LSP, tree-sitter, imenu, project) to Claude over MCP.
(use-package! claude-code-ide
  :config
  ;; Claude's own theme is a settings key, not a flag; --settings takes literal
  ;; JSON and the command is assembled into a shell string, so this pins the
  ;; light theme for Emacs-hosted sessions without touching ~/.claude/settings.json.
  ;; `--permission-mode auto' is how these sessions get started by hand; keep it
  ;; scoped to Emacs-hosted ones rather than baking it into ~/.claude/settings.json.
  (setq claude-code-ide-cli-extra-flags
        "--settings '{\"theme\":\"light\"}' --permission-mode auto")
  (setq claude-code-ide-terminal-backend 'ghostel
        ;; No effect unless `evil-ghostel' is loaded. `terminal' always sends
        ;; insert-state ESC to Claude, so it stays the interrupt key -- `auto'
        ;; would route it to evil here, since the inline renderer never enters
        ;; the alt screen. Use `C-c ESC' (evil-force-normal-state) to reach
        ;; normal state once for scrolling or copying, without changing routing.
        claude-code-ide-ghostel-evil-escape 'terminal
        claude-code-ide-show-backend-recommendation nil
        claude-code-ide-enable-mcp-server t
        ;; Let Doom's popup system own the window instead of the package's own
        ;; side-window code, so it behaves exactly like `<leader> o t'.
        claude-code-ide-use-side-window nil)
  (claude-code-ide-emacs-tools-setup)

  ;; The Emacs MCP server only dispatches initialize/tools/list/tools/call
  ;; (claude-code-ide-mcp-http-server.el:181-193), but the Claude CLI probes
  ;; resources/list and prompts/list right after the handshake. Those fall to
  ;; the `_' branch, which signals `json-rpc-error' -- a symbol the package
  ;; never `define-error's, so it is not an `error' subtype, escapes the
  ;; handler at :178, and surfaces as
  ;;   error in process filter: peculiar error: -32601, "Method not found"
  ;; Answer the probes with empty lists, and make any other unknown method
  ;; degrade into a normal JSON-RPC error response instead of a broken filter.
  (define-error 'json-rpc-error "JSON-RPC error" 'error)

  (defun +claude-code-ide-mcp-empty-listings-a (method &rest _)
    "Answer MCP listing probes the Emacs server does not implement."
    (pcase method
      ("resources/list" '((resources . [])))
      ("resources/templates/list" '((resourceTemplates . [])))
      ("prompts/list" '((prompts . [])))))

  (advice-add 'claude-code-ide-mcp-http-server--dispatch
              :before-until #'+claude-code-ide-mcp-empty-listings-a)

  ;; Claude Code 2.1.x drives its TUI on the alternate screen, and a terminal on
  ;; the alt screen has no scrollback by definition -- scrolled-off output is
  ;; discarded rather than materialised into the ghostel buffer, so there is no
  ;; conversation history to scroll back through in Emacs (the buffer is exactly
  ;; as tall as the window). The CLI ships an opt-out; keep it scoped to the
  ;; sessions we spawn rather than leaking into Emacs' own environment.
  (defun +claude-code-ide-inline-screen-a (fn &rest args)
    "Run Claude without the alternate screen so ghostel keeps a scrollback."
    (let ((process-environment
           (cons "CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1" process-environment)))
      (apply fn args)))

  (advice-add 'claude-code-ide--create-terminal-session
              :around #'+claude-code-ide-inline-screen-a))

;; `evil-ghostel-mode' (which `claude-code-ide-ghostel-evil-escape' needs to be
;; active in the buffer -- claude-code-ide.el:536) and the comint/compile/eshell
;; integration both come from `:term (ghostel +everywhere)' in init.el.

;; Keep the native module outside straight's build tree: `doom sync' rebuilds
;; that directory and deletes the .so out from under a running Emacs, which is
;; what produces "Native module not found" on the next check.
(setq ghostel-module-directory (expand-file-name "ghostel/" doom-data-dir))

;; A CLAUDE_* set leaks into Emacs' `process-environment' from whichever Claude
;; session last touched it, and every terminal we spawn inherits it. The
;; CHILD_SESSION marker makes Claude treat the session as a sub-agent and skip
;; writing a transcript, so `/resume' never sees Emacs-hosted sessions. Strip
;; them at spawn time, mirroring the module's own direnv hook.
(after! ghostel
  (add-hook! 'ghostel-pre-spawn-hook
    (defun +ghostel-strip-stale-claude-vars-h (&rest _)
      (setq-local process-environment
                  (seq-remove (lambda (v)
                                (string-match-p
                                 (rx bos (or "CLAUDECODE" "CLAUDE_PID" "CLAUDE_EFFORT"
                                             "CLAUDE_CODE_CHILD_SESSION"
                                             "CLAUDE_CODE_SESSION_ID"
                                             "CLAUDE_CODE_BRIDGE_SESSION_ID"
                                             "CLAUDE_CODE_EXECPATH"
                                             "CLAUDE_CODE_ENTRYPOINT"
                                             "CLAUDE_CODE_MESSAGING_SOCKET"
                                             "CLAUDE_CODE_MESSAGING_TOKEN")
                                     "=")
                                 v))
                              process-environment)))))

;; claude-code-ide registers only `^/mcp\(/.*\)?$' handlers with `ws-start'
;; (claude-code-ide-mcp-http-server.el:90), and emacs-web-server answers every
;; unmatched path with a 500 (web-server.el:335). Claude Code probes
;; /.well-known/oauth-authorization-server before connecting and reads that 500
;; as a failed OAuth discovery -- hence "MCP server needs authentication".
;; Appending a catch-all 404 makes the probe answer "no OAuth here".
;; Upstream bug: https://github.com/manzaltu/claude-code-ide.el/issues/180
(defun +claude-code-ide--ws-send-404 (request)
  "Answer REQUEST with a 404 instead of letting web-server fall through to 500."
  (ws-send-404 (ws-process request)))

(defun +claude-code-ide--ws-start-catch-all (args)
  "Append catch-all 404 handlers to ARGS when `ws-start' is claude-code-ide's."
  (let ((handlers (car args)))
    (if (and (consp handlers)
             (cl-some (lambda (h)
                        (and (consp (car h))
                             (equal (cdar h) "^/mcp\\(/.*\\)?$")))
                      handlers))
        (cons (append handlers
                      `(((:GET . ".") . ,#'+claude-code-ide--ws-send-404)
                        ((:POST . ".") . ,#'+claude-code-ide--ws-send-404)
                        ((:HEAD . ".") . ,#'+claude-code-ide--ws-send-404)))
              (cdr args))
      args)))

(advice-add 'ws-start :filter-args #'+claude-code-ide--ws-start-catch-all)

;; Doom exempts `vterm-mode' from these three, but nothing teaches them about
;; `ghostel-mode' (corfu/config.el:71, nav-flash/config.el:9, evil/config.el:403),
;; so without this, completion, nav-flash and evil-escape all fire inside
;; terminal buffers that used to be exempt.
(after! corfu
  (when-let* ((not-clause (assq 'not global-corfu-modes)))
    (cl-pushnew 'ghostel-mode (cdr not-clause))))

(after! nav-flash
  (add-to-list '+nav-flash-exclude-modes 'ghostel-mode))

(after! evil-escape
  (add-to-list 'evil-escape-excluded-major-modes 'ghostel-mode))

;; Mirrors Doom's own terminal popup rule (term/vterm/config.el:18), on its own
;; vslot so Claude and a `<leader> o t' terminal don't evict each other.
(set-popup-rule! "^\\*claude-code" :size 0.25 :vslot -5 :select t :quit nil :ttl 0)

;; `claude-code-ide-mcp--sessions-for-project' documents its return value as
;; unordered (claude-code-ide-mcp.el:162) -- it just walks a hash table -- and
;; the package's own switchers sort by last-used, which reshuffles the list on
;; every jump. Cycling needs a *stable* order, so sort by display name.
(defun +claude-code-ide--ordered-sessions ()
  "Return this project's Claude sessions in a stable, name-sorted order."
  (sort (claude-code-ide-mcp--sessions-for-project
         (claude-code-ide--get-working-directory))
        (lambda (a b)
          (string< (claude-code-ide--session-display-name a)
                   (claude-code-ide--session-display-name b)))))

(defun +claude-code-ide-cycle-session (n)
  "Switch to the Nth session after the current one, wrapping around.
The starting point is the Claude terminal at point, else the last one
visited, else the first session in order."
  (claude-code-ide--cleanup-dead-sessions)
  (let ((sessions (+claude-code-ide--ordered-sessions)))
    (unless sessions
      (user-error "No Claude Code session for this project"))
    (let* ((current (or (claude-code-ide--buffer-session)
                        (cl-find claude-code-ide--last-accessed-buffer sessions
                                 :key #'claude-code-ide-mcp-session-buffer)))
           ;; With no anchor, `[' and `]' should both land on the first
           ;; session rather than skipping past it.
           (index (if current
                      (mod (+ (cl-position current sessions) n) (length sessions))
                    0))
           (session (nth index sessions))
           (buffer (claude-code-ide-mcp-session-buffer session)))
      (unless (buffer-live-p buffer)
        (user-error "Buffer for %s no longer exists"
                    (claude-code-ide--session-display-name session)))
      (select-window (or (get-buffer-window buffer)
                         (claude-code-ide--display-buffer-in-side-window buffer)))
      (claude-code-ide--touch-session session)
      (message "Claude instance %d/%d: %s"
               (1+ index) (length sessions)
               (claude-code-ide--session-display-name session)))))

(defun +claude-code-ide-next-session ()
  "Switch to the next Claude Code session of this project."
  (interactive)
  (+claude-code-ide-cycle-session 1))

(defun +claude-code-ide-prev-session ()
  "Switch to the previous Claude Code session of this project."
  (interactive)
  (+claude-code-ide-cycle-session -1))

;; A key is either a command or a prefix, never both, so the menu moves down to
;; `o c c' to make room for the cycling pair.
(map! :leader
      (:prefix ("o c" . "Claude Code")
       :desc "Claude Code menu"     "c" #'claude-code-ide-menu
       :desc "Previous Claude session" "[" #'+claude-code-ide-prev-session
       :desc "Next Claude session"     "]" #'+claude-code-ide-next-session))
