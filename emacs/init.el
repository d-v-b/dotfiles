;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode nil)
        (setq python-indent 4)
        (setq tab-width 4))
      (untabify (point-min) (point-max)))

(require 'package)
(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
<<<<<<< HEAD
   flycheck
   material-theme
   elpy
   dockerfile-mode))
=======
    flycheck
    material-theme
    elpy))
>>>>>>> b415989ac8f16a5bfcffc206b4fd31dbcd637d43

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;(setq shell-file-name "/bin/bash")
;(setq elpy-rpc-python-command "~/anaconda3/bin/python")
;(elpy-enable)


;; BASIC CUSTOMIZATION
;; --------------------------------------
(desktop-save-mode 1)
(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; Flycheck
(global-flycheck-mode)
(package-install 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (misterioso)))
 '(fci-rule-color "#37474f")
 '(hl-sexp-background-color "#1c1f26")
<<<<<<< HEAD
 '(package-selected-packages (quote (magit org-ednaee)))
=======
 '(package-selected-packages (quote (exec-path-from-shell go-mode org-ednaee)))
>>>>>>> b415989ac8f16a5bfcffc206b4fd31dbcd637d43
 '(python-shell-exec-path (quote ("")))
 '(python-shell-interpreter "/Users/bennettd/anaconda3/bin/python")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#f36c60")
     (40 . "#ff9800")
     (60 . "#fff59d")
     (80 . "#8bc34a")
     (100 . "#81d4fa")
     (120 . "#4dd0e1")
     (140 . "#b39ddb")
     (160 . "#f36c60")
     (180 . "#ff9800")
     (200 . "#fff59d")
     (220 . "#8bc34a")
     (240 . "#81d4fa")
     (260 . "#4dd0e1")
     (280 . "#b39ddb")
     (300 . "#f36c60")
     (320 . "#ff9800")
     (340 . "#fff59d")
     (360 . "#8bc34a"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; init.el ends here
