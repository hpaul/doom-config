;;; cli.el -*- lexical-binding: t; -*-

;; Warm the native-comp cache after every `doom sync' (see bin/warm-eln).
;; DESTINATION 0 detaches it, so sync returns at once.
(add-hook 'doom-after-sync-hook
          (defun +warm-eln-h ()
            (when (eq system-type 'darwin)
              (call-process (expand-file-name "bin/warm-eln" doom-user-dir) nil 0))))
