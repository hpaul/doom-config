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

;; A directory in `org-agenda-files' is scanned one level deep only, so
;; per-project folders under ~/org/projects/ have to be listed explicitly.
(after! org
  (setq org-agenda-files (list "~/org/" "~/org/projects/sogood/")))

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

;; -------------------------------------------------
;;  A reachable, stable Emacs server
;; -------------------------------------------------
;; Several Emacs instances run at once here, and they cannot share one socket.
;; Nothing about a process is both unique *and* stable across restarts -- a PID
;; is unique but changes, the launch directory is stable but identical for every
;; instance -- so the name has to come from how you start it:
;;
;;   emacs                        -> `emacsclient' (the default socket)
;;   EMACS_SERVER_NAME=sogood emacs -> `emacsclient -s sogood', forever
;;
;; Without the variable nothing changes, so the primary instance and every
;; existing `emacsclient' invocation keep working.
(setq server-name (or (getenv "EMACS_SERVER_NAME") "server"))

;; Start it if that name is free. Doom does not start a server on its own, which
;; is why one of these instances was unreachable and `emacsclient' kept landing
;; in a sibling without saying so.
(add-hook! 'doom-first-input-hook
  (defun +server-start-h ()
    (require 'server)
    (cond ((process-live-p server-process))  ; ours already, nothing to do
          ;; `server-running-p' is true for a socket held by *another* Emacs, so
          ;; this branch is the one that used to happen silently: no server here,
          ;; and `emacsclient' quietly answering from a sibling instead.
          ((server-running-p server-name)
           (message "Emacs server `%s' belongs to another instance -- set EMACS_SERVER_NAME to get your own"
                    server-name))
          (t (server-start)))))

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
;;
;; Locate the suffixes by command, never by key: a key lookup is a lookup of the
;; very thing being reassigned, so a second evaluation chases keys that have
;; already moved and dies with "c not found in magit-branch" -- which took out
;; `doom/reload' entirely. By command it is idempotent, and the old ordering
;; constraint (n -> N before c -> n) goes away with it.
(after! magit
  (transient-suffix-put 'magit-branch #'magit-branch-create       :key "N")
  (transient-suffix-put 'magit-branch #'magit-branch-and-checkout :key "n")
  (transient-suffix-put 'magit-rebase #'magit-rebase-branch       :key "r"))

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

;; Umbrella repos (~/apps/sogood) hold their sub-projects as submodules, but
;; magit's default `magit-status-sections-hook' has no module inserters at all,
;; so a superproject status says nothing about them. `magit-insert-modules'
;; expands `magit-module-sections-hook', which already carries the overview plus
;; the unpulled/unpushed pairs.
;;
;; This only pays off with `ignore' relaxed in .gitmodules -- at `all' git itself
;; reports nothing for magit to render. Those repos are on `dirty': moved
;; gitlinks show, uncommitted worktree churn inside a submodule does not.
(after! magit
  (magit-add-section-hook 'magit-status-sections-hook
                          #'magit-insert-modules
                          #'magit-insert-stashes
                          'append))

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

;; Open dired when opening a project -- but *through* the workspaces module.
;; Doom points `projectile-switch-project-action' at `+workspaces-switch-to-
;; project-h' (ui/workspaces/config.el:179); that handler is what gives a project
;; its own workspace and names it after the project. Setting the action directly
;; to `projectile-dired' quietly replaced it, so `SPC p p' opened dired and never
;; touched workspaces at all -- which is why they kept their `#1' names.
;; `+workspaces-switch-project-function' is the seam the module provides for the
;; "and then do this" part, and it is called with the project root.
(defun +workspaces-dired-h (dir)
  "Open DIR in dired, after the workspace for it has been set up."
  (dired dir))

(after! projectile
  (setq! projectile-switch-project-action #'+workspaces-switch-to-project-h))

(after! persp-mode
  (setq +workspaces-switch-project-function #'+workspaces-dired-h))

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
;;  Workspaces as tabs across the top of the frame
;; -------------------------------------------------------------------
;; `tab-bar-mode' owns the strip above the frame, but its *tabs* are frame-local
;; window configurations -- unrelated to persp-mode's perspectives, which is what
;; Doom's workspaces are. So take the bar and ignore the tabs: `tab-bar-format'
;; is just a list of functions returning strings, and Doom already has a renderer
;; in `+workspace--tabline' (workspaces.el:472), faces and all.
;;
;; Clicking a tab does nothing. tab-bar's mouse handling is hardcoded to real
;; tabs, and the only working fix computes each tab's pixel width by hand. Not
;; worth it for a bar driven entirely from `SPC TAB'.
(after! persp-mode
  (defun +workspace-tab-bar-line ()
    (+workspace--tabline))

  ;; The bar redraws when its *string* changes, not when a face does -- so a
  ;; switch would otherwise leave the previous tab highlighted. Emitting the
  ;; current name invisibly changes the string too, forcing the redraw.
  (defun +workspace-tab-bar-force-redraw ()
    (propertize (+workspace-current-name) 'invisible t))

  (setq tab-bar-format '(+workspace-tab-bar-line
                         tab-bar-format-align-right
                         +workspace-tab-bar-force-redraw))

  ;; Only worth screen space once there is a choice to make. Deleting down to
  ;; one workspace leaves the bar up until the next switch: `persp-before-kill-
  ;; functions' runs while the count is still high.
  (defun +workspace-tab-bar-toggle-h (&rest _)
    (tab-bar-mode (if (> (length (+workspace-list-names)) 1) +1 -1)))
  (dolist (hook '(persp-created-functions persp-activated-functions
                  persp-renamed-functions persp-before-kill-functions))
    (add-hook hook #'+workspace-tab-bar-toggle-h))

  ;; `SPC p p' already names a workspace after its project (workspaces.el:556);
  ;; `SPC TAB n' falls back to `#1', `#2'. Name it after the project too -- but
  ;; uniquified, or opening a second workspace on the same project would hit
  ;; `+workspace/new's "already exists" error (workspaces.el:335).
  (defun +workspace--project-name ()
    "Return the current project's name, made unique among open workspaces."
    (when-let* ((base (and (doom-project-p) (doom-project-name))))
      (let ((name base) (n 1))
        (while (+workspace-exists-p name)
          (setq n (1+ n) name (format "%s %d" base n)))
        name)))

  (defadvice! +workspace-new-named-after-project-a (fn &optional name clone-p)
    "Give `SPC TAB n' the project's name instead of a generated id."
    :around #'+workspace/new
    (funcall fn (or name (+workspace--project-name)) clone-p))

  ;; The list is on screen permanently now; echoing it on every switch is noise.
  (advice-add #'+workspace/display :override #'ignore))

;; `highlight' is loud in modus-operandi-tinted. Enough contrast to find the
;; current workspace at a glance, not enough to pull the eye off the buffer.
(custom-set-faces!
  '(+workspace-tab-face :inherit mode-line-inactive :weight light)
  '(+workspace-tab-selected-face :inherit mode-line-emphasis :weight bold))


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

;; Kitty renders this TUI in JetBrainsMono and it reads better there. Only the
;; terminal moves -- `ghostel-default' is remapped over `default' per buffer
;; (ghostel.el:5157), so the rest of Emacs stays on JuliaMono. :height 140 is
;; kitty's `font_size 14.0'. Kitty's `font_features' (+zero +ss20 +onum +cv06)
;; have no Emacs equivalent, so the fine glyph detail still differs.
(after! ghostel
  (set-face-attribute 'ghostel-default nil
                      :family "JetBrainsMono Nerd Font"
                      :height 140))

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

;; Mirrors Doom's own terminal popup rule (term/vterm/config.el:18), and shares
;; its vslot deliberately: `<leader> o t' is already on -5, so a terminal and
;; Claude take turns in one window instead of splitting the frame between them.
(set-popup-rule! "^\\*claude-code" :size 0.25 :vslot -5 :select t :quit nil :ttl 0)

;; `+ghostel-new-buffer' names through `ghostel--project-buffer-name', which is
;; `*<project>-ghostel*' -- a shape neither rule above matched, so a new terminal
;; opened in a window of its own rather than over the one it was launched from.
;; `:height' is spelled out because `window-height' reads `:height', never
;; `:size' (ui/popup/autoload/settings.el:26); left off, `+popup-defaults' hands
;; it 0.16 and the popup resizes every time you swap it with a Claude buffer.
(set-popup-rule! "^\\*[^*]+-ghostel\\*"
                 :size 0.25 :height 0.25 :vslot -5 :select t :quit nil :ttl 0)

;; Every terminal this project owns is a ghostel buffer -- Claude sessions and
;; plain shells alike -- so one ring reaches all of them. See the keybinding
;; note further down: `C-{' / `C-}' walks it, from normal state and from inside
;; a terminal both.
(defun +ghostel--buffer-project (buffer)
  "Return BUFFER's project root, honouring `+project-umbrella-root'.
Claude terminals answer from their session, which is pinned at spawn
time and so survives a `cd' inside the shell."
  (or (when (fboundp 'claude-code-ide--buffer-session)
        (when-let* ((session (claude-code-ide--buffer-session buffer)))
          (expand-file-name (claude-code-ide-mcp-session-project-dir session))))
      (with-current-buffer buffer
        (when-let* ((project (project-current)))
          (expand-file-name (project-root project))))))

(defun +ghostel--ordered-buffers ()
  "Return this project's live ghostel buffers, in a stable name order."
  (let ((root (+ghostel--buffer-project (current-buffer))))
    (sort (cl-remove-if-not
           (lambda (buffer)
             (and (eq (buffer-local-value 'major-mode buffer) 'ghostel-mode)
                  root
                  (equal (+ghostel--buffer-project buffer) root)))
           (buffer-list))
          (lambda (a b) (string< (buffer-name a) (buffer-name b))))))

(defun +ghostel-cycle-buffer (n)
  "Switch to the Nth ghostel terminal after this one, wrapping around."
  (let ((buffers (+ghostel--ordered-buffers)))
    (unless buffers
      (user-error "No ghostel terminal for this project"))
    (let* ((position (cl-position (current-buffer) buffers))
           (index (if position (mod (+ position n) (length buffers)) 0))
           (buffer (nth index buffers)))
      (if-let* ((window (get-buffer-window buffer)))
          (select-window window)
        (pop-to-buffer buffer))
      ;; Keep claude-code-ide's MRU bookkeeping honest, so `SPC o c ]' and the
      ;; package's own switchers agree with where we just landed.
      (when (fboundp 'claude-code-ide--touch-session)
        (when-let* ((session (claude-code-ide--buffer-session buffer)))
          (claude-code-ide--touch-session session)))
      (message "Terminal %d/%d: %s"
               (1+ index) (length buffers) (buffer-name buffer)))))

(defun +ghostel-next-buffer ()
  "Switch to the next ghostel terminal of this project."
  (interactive)
  (+ghostel-cycle-buffer 1))

(defun +ghostel-prev-buffer ()
  "Switch to the previous ghostel terminal of this project."
  (interactive)
  (+ghostel-cycle-buffer -1))

(defun +ghostel-new-buffer ()
  "Open a new terminal at this project's root, and switch to it.
`default-directory' follows the shell, so a `cd' inside a terminal would
otherwise decide where the next one starts.  `+ghostel--buffer-project'
answers from the Claude session instead, which is pinned at spawn time.

Displayed the same way the ring displays: `pop-to-buffer', so Doom's popup
rules place it and a dedicated window is never fought over."
  (interactive)
  (let ((default-directory (or (+ghostel--buffer-project (current-buffer))
                               default-directory)))
    (dlet ((ghostel-buffer-name (ghostel--project-buffer-name default-directory)))
      ;; A non-numeric prefix arg makes `ghostel' create a buffer instead of
      ;; reusing the one that name resolves to (ghostel.el:5486).
      (pop-to-buffer (save-window-excursion (ghostel '(4)))))))

;; -----------------------------------------------------------------------------
;; Resume a past Claude session from a completing-read list
;; -----------------------------------------------------------------------------
;; `claude-code-ide-resume' passes a bare `-r' and leaves you in the CLI's own
;; TUI picker (claude-code-ide.el:1132). `claude -r <session-id>' resumes
;; directly, so the picker can be an Emacs one instead.
;;
;; Transcripts live in ~/.claude/projects/<dir>/<session-uuid>.jsonl, where <dir>
;; is the working directory with `/' and `.' flattened to `-'. That working
;; directory is `claude-code-ide--get-working-directory', so `+project-umbrella-root'
;; is already accounted for.
(defun +claude-code-ide--transcript-directory (project-dir)
  "Return the ~/.claude/projects directory holding PROJECT-DIR's transcripts."
  (expand-file-name
   (replace-regexp-in-string "[/.]" "-" (directory-file-name project-dir))
   (expand-file-name "~/.claude/projects/")))

(defun +claude-code-ide--session-titles (dir)
  "Return a hash of session id -> title for the transcripts in DIR.
Claude appends an `ai-title' record whenever it renames a conversation, so
the last one wins.  Those records are uniform ~111-byte lines, which is why
`rg' does the filtering: it discards the bulk of the corpus (445MB across 57
sessions on the largest project here) and hands `jq' a few thousand tiny
objects, turning a 1.85s all-lines parse into 0.09s end to end.  Cold cache
still pays for the read."
  (let ((titles (make-hash-table :test #'equal)))
    (with-temp-buffer
      (call-process
       "sh" nil t nil "-c"
       ;; `env -u RIPGREP_CONFIG_PATH' rather than overriding single flags:
       ;; ~/.ripgreprc carries `--max-columns=80 --max-columns-preview', which
       ;; truncates these records into invalid JSON, and a future
       ;; `--max-filesize' there would silently drop the largest transcripts.
       (format "env -u RIPGREP_CONFIG_PATH rg --no-filename --no-line-number '\"type\":\"ai-title\"' -g '*.jsonl' %s | jq -r '[.sessionId,.aiTitle]|@tsv'"
               (shell-quote-argument dir)))
      (goto-char (point-min))
      (while (re-search-forward "^\\([^\t\n]+\\)\t\\(.*\\)$" nil t)
        (puthash (match-string 1) (match-string 2) titles)))
    titles))

(defun +claude-code-ide--transcripts (project-dir)
  "Return PROJECT-DIR's past sessions as (ID TIME TITLE), newest first."
  (let ((dir (+claude-code-ide--transcript-directory project-dir)))
    (when (file-directory-p dir)
      (let ((titles (+claude-code-ide--session-titles dir))
            rows)
        ;; Modification times come straight from the directory listing -- no
        ;; second subprocess, and no need to read the files at all.
        (pcase-dolist (`(,file . ,attributes)
                       (directory-files-and-attributes dir nil "\\.jsonl\\'" t))
          (let ((id (file-name-base file)))
            (push (list id
                        (file-attribute-modification-time attributes)
                        (gethash id titles))
                  rows)))
        (sort rows (lambda (a b) (time-less-p (nth 1 b) (nth 1 a))))))))

(defun +claude-code-ide--instance-name-from-title (title project-dir)
  "Turn TITLE into an instance name that is free in PROJECT-DIR.
Nil when TITLE cannot yield a usable one, which leaves auto-numbering
to the package.  Mirrors the validation in
`claude-code-ide--read-instance-name' (claude-code-ide.el:825-830):
`[', `]', `*' and control characters are rejected outright, and a purely
numeric name collides with the auto-number slots."
  (when title
    (let* ((clean (string-trim (replace-regexp-in-string "[][*[:cntrl:]]" "" title)))
           ;; Drop the trailing partial word so the buffer name reads as a
           ;; phrase: "Integrate Claude Code", not "Integrate Claude Code wi".
           (clean (string-trim
                   (if (<= (length clean) 24)
                       clean
                     (let ((cut (substring clean 0 24)))
                       (if (string-match "\\`\\(.+\\) [^ ]*\\'" cut)
                           (match-string 1 cut)
                         cut)))))
           (taken (mapcar #'claude-code-ide-mcp-session-instance-name
                          (claude-code-ide-mcp--sessions-for-project project-dir))))
      (unless (or (string-empty-p clean)
                  (string-match-p "\\`[0-9]+\\'" clean))
        (let ((name clean) (n 1))
          ;; Resuming the same conversation twice must not produce two
          ;; instances that `claude-code-ide--session-display-name' renders
          ;; identically -- the switchers key off that string.
          (while (member name taken)
            (setq n (1+ n)
                  name (format "%s %d" clean n)))
          name)))))

(defun +claude-code-ide-resume-from-list ()
  "Resume one of this project's past Claude sessions in a new instance.
Lists them newest first, by the title Claude gave the conversation, and
names the instance after it.  With a prefix argument, ask for the name
the way the package does."
  (interactive)
  (let* ((project-dir (claude-code-ide--get-working-directory))
         (rows (+claude-code-ide--transcripts project-dir))
         (prompt-for-name current-prefix-arg))
    (unless rows
      (user-error "No past Claude sessions for %s" (abbreviate-file-name project-dir)))
    (let* ((candidates
            (mapcar (pcase-lambda (`(,id ,time ,title))
                      ;; The id tail keeps entries unique: two conversations
                      ;; can carry the same title, and `completing-read' would
                      ;; otherwise resolve to whichever came first.
                      (cons (format "%s  %-58s  %s"
                                    (format-time-string "%m-%d %H:%M" time)
                                    (or title "(untitled)")
                                    (substring id 0 8))
                            (cons id title)))
                    rows))
           ;; `identity' as the sort function keeps our recency order; vertico
           ;; would otherwise re-sort by history and length.
           (table (lambda (string predicate action)
                    (if (eq action 'metadata)
                        '(metadata (display-sort-function . identity)
                                   (cycle-sort-function . identity))
                      (complete-with-action action candidates string predicate))))
           (choice (completing-read "Resume Claude session: " table nil t))
           (entry (cdr (assoc choice candidates)))
           (id (car entry))
           (name (+claude-code-ide--instance-name-from-title (cdr entry) project-dir))
           ;; No advice needed: `claude-code-ide--build-claude-command' appends
           ;; these flags verbatim (claude-code-ide.el:1150), so the instance is
           ;; built exactly like any other -- MCP server, popup, bookkeeping.
           (claude-code-ide-cli-extra-flags
            (string-trim (concat claude-code-ide-cli-extra-flags
                                 " --resume " (shell-quote-argument id)))))
      ;; `claude-code-ide--start-session' prompts for a name whenever the
      ;; project already has an instance (claude-code-ide.el:1397) -- which is
      ;; the normal case when resuming. We already know what to call it, so
      ;; answer the reader instead of asking. `current-prefix-arg' is consumed
      ;; here rather than passed through: it would otherwise force the prompt
      ;; via the same condition, which is exactly what it should do.
      (if prompt-for-name
          (claude-code-ide--start-session nil nil)
        (cl-letf (((symbol-function 'claude-code-ide--read-instance-name)
                   (lambda (project-dir &rest _)
                     (or name (claude-code-ide--auto-instance-name project-dir))))
                  (current-prefix-arg nil))
          (claude-code-ide--start-session nil nil))))))

;; Terminals answer to the same chords kitty uses, and to nothing else:
;;
;;   C-{ / C-}        previous / next terminal, one ring for the whole project
;;   C-S-<return>     new terminal at the project root
;;
;; `C-{' is the ctrl+shift+[ chord spelled the way Emacs receives it -- `{'
;; already carries Shift, and `C-S-[' resolves to `S-ESC' because `C-[' *is*
;; ESC. ghostel's modifier loop covers only its named special keys
;; (ghostel.el:1226), so it never claims `C-{' or `C-}' and they reach Emacs
;; from inside a terminal untouched. One global binding therefore serves normal
;; state and the terminal alike, which is why the bracket pair and the `C-c ['
;; duplicates are both gone -- `[t' / `]t' and `[c' / `]c' are Doom's hl-todo
;; and comment motions again, unshifted, where a reader expects them.
;;
;; `[w' / `]w' stays the workspace ring: it is Doom's, it is a real motion, and
;; it is the one thing here that isn't a terminal.
(map! "C-{" #'+ghostel-prev-buffer
      "C-}" #'+ghostel-next-buffer)

(after! ghostel
  ;; `<return>' is one of ghostel's special keys, and the loop binds it under
  ;; every modifier including `C-S-', so this one chord has to be excused before
  ;; Emacs can see it. The defcustom's :set rebuilds the semi-char keymap
  ;; (ghostel.el:694), which `setopt' triggers and `setq' would not. Guarded so
  ;; a reload doesn't grow the list.
  (unless (member "C-S-<return>" ghostel-keymap-exceptions)
    (setopt ghostel-keymap-exceptions
            (cons "C-S-<return>" ghostel-keymap-exceptions)))

  ;; `C-c [' was the terminal ring itself; it has to stop being a command before
  ;; it can be a prefix. Unbinding explicitly keeps a reload idempotent.
  (define-key ghostel-mode-map (kbd "C-c [") nil)
  (define-key ghostel-mode-map (kbd "C-c ]") nil)
  ;; Only the workspace ring needs `C-c' now: `[w' is a Doom motion with no
  ;; control-key spelling, so the terminal reaches it the long way round.
  (map! :map ghostel-mode-map
        "C-c [ w" #'+workspace/switch-left
        "C-c ] w" #'+workspace/switch-right
        "C-S-<return>" #'+ghostel-new-buffer)

  ;; `C-c c' *is* `SPC o c' -- the leader's own submap, not a copy of it. A copy
  ;; is how the two drifted: the same command sat on `s' here and `n' there, and
  ;; `c' meant "continue" here but "menu" there. The `:filter' resolves the
  ;; submap at lookup time, so it cannot go stale and does not care that the
  ;; leader map is defined further down this file.
  (define-key ghostel-mode-map (kbd "C-c c")
              `(menu-item "" nil
                          :filter ,(lambda (_)
                                     (lookup-key doom-leader-map (kbd "o c"))))))

;; Every `o c' binding lives here, not split across the `after!' block above:
;; two `map!' forms on one prefix silently resolve by evaluation order, which is
;; not something a reader should have to work out.
;;
;; A key is either a command or a prefix, never both, so the menu sits on
;; `o c c' rather than on `o c' itself.
;; `claude-code-ide-resume' is deliberately absent: it opens the CLI's own TUI
;; picker, which the menu still reaches, and `r' is better spent on our list.
;; Cycling is not here either -- that is `C-{' / `C-}', with every terminal.
(map! :leader
      (:prefix ("o c" . "Claude Code")
       :desc "Claude Code menu"        "c" #'claude-code-ide-menu
       :desc "New session"             "n" #'claude-code-ide
       :desc "Continue last session"   "C" #'claude-code-ide-continue
       :desc "Toggle window"           "t" #'claude-code-ide-toggle
       ;; Also on the leader, not just `C-c c r': resuming is exactly what you
       ;; reach for when the project has no terminal to press `C-c' in.
       :desc "Resume past session"     "r" #'+claude-code-ide-resume-from-list
       :desc "List sessions"           "l" #'claude-code-ide-list-sessions
       :desc "Stop session"            "k" #'claude-code-ide-stop))
