;;; early-init.el --- loaded before init.el and the first frame  -*- lexical-binding: t; -*-

;;; Commentary:
;; Keep this minimal: raise the GC threshold for the duration of startup
;; (gcmh in init.el restores a sane value afterwards) and suppress UI
;; elements before the first frame is drawn so they don't flash.

;;; Code:

(setq gc-cons-threshold most-positive-fixnum)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t)

;;; early-init.el ends here
