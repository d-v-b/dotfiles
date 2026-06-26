;;; init-linux.el --- Linux-specific Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Loaded by init.el when `system-type' is gnu/linux (see the PATH/environment
;; section there).  The shared init.el already adds ~/.local/bin and ~/.cargo/bin
;; and runs exec-path-from-shell in graphical sessions -- keep only Linux-only
;; settings here.

;;; Code:

(declare-function my/add-exec-dir "init")   ; defined in init.el before this loads

;; pixi installs per-project tool shims under ~/.pixi/bin.
(my/add-exec-dir "~/.pixi/bin")

(provide 'init-linux)
;;; init-linux.el ends here
