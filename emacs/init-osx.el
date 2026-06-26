;;; init-osx.el --- macOS-specific Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Loaded by init.el when `system-type' is darwin (see the PATH/environment
;; section there).  The shared init.el already adds ~/.local/bin and ~/.cargo/bin
;; and runs exec-path-from-shell in graphical sessions -- keep only macOS-only
;; settings here.

;;; Code:

(declare-function my/add-exec-dir "init")   ; defined in init.el before this loads

;; GUI Emacs on macOS launches without the shell's PATH, so package-manager bin
;; dirs must be added explicitly (exec-path-from-shell then imports the rest).
(my/add-exec-dir "/opt/homebrew/bin")   ; Homebrew, Apple Silicon
(my/add-exec-dir "/usr/local/bin")      ; Homebrew, Intel
(my/add-exec-dir "/opt/local/bin")      ; MacPorts (matches ~/.zshrc.osx)

(provide 'init-osx)
;;; init-osx.el ends here
