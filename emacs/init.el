;;; init.el --- Modern Emacs config with a Python IDE focus  -*- lexical-binding: t; -*-

;;; Commentary:
;; A from-scratch Emacs 30 configuration built around current (2026) best
;; practices for Python development:
;;
;;   * eglot (built-in) for LSP, with basedpyright / ty / pyright alternatives
;;   * python-ts-mode (tree-sitter) as the major mode
;;   * ruff (via reformatter) for format + import sorting, format-on-save
;;   * pet.el for zero-config per-project virtualenv detection
;;   * eglot-booster for faster LSP I/O
;;   * vertico / orderless / marginalia / consult (minibuffer completion)
;;   * corfu / cape (in-buffer completion)
;;
;; External tools expected on PATH (installed under ~/.local/bin and
;; ~/.cargo/bin): ruff, basedpyright-langserver, ty, emacs-lsp-booster.

;;; Code:

;;; ----------------------------------------------------------------------------
;;; Package management & use-package
;;; ----------------------------------------------------------------------------

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; use-package ships with Emacs 29+; make every :package install by default.
(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

;;; ----------------------------------------------------------------------------
;;; PATH / environment
;;; ----------------------------------------------------------------------------
;; Emacs (especially the snap build, or any non-login GUI launch) can start with
;; a stripped PATH, so external tools (ruff, basedpyright, ty, emacs-lsp-booster)
;; may not be found.  Add the well-known user bin dirs explicitly, then let
;; exec-path-from-shell import the full login PATH in graphical sessions.

(defun my/add-exec-dir (dir)
  "Prepend DIR to `exec-path' and the PATH env var, if DIR exists.
Return non-nil when DIR was added.  Shared with the OS-specific init files."
  (let ((dir (expand-file-name dir)))
    (when (file-directory-p dir)
      (add-to-list 'exec-path dir)
      (setenv "PATH" (concat dir path-separator (getenv "PATH")))
      t)))

;; Common to every platform.
(mapc #'my/add-exec-dir '("~/.local/bin" "~/.cargo/bin"))

;; OS-specific configuration (extra PATH dirs, platform tweaks) lives in
;; init-osx.el / init-linux.el beside this file in the dotfiles repo.  Resolve
;; this file's *true* path first so the fragment loads from the repo even though
;; ~/.emacs.d/init.el is a symlink -- no need to symlink the fragments too.
;; Loaded here, early, so any PATH additions land before tools are needed.
(let* ((this  (file-truename (or load-file-name user-init-file)))
       (osdir (file-name-directory this))
       (osel  (pcase system-type
                ('darwin "init-osx")
                (_       "init-linux"))))
  (load (expand-file-name osel osdir) t))   ; t -> no error if the file is absent

(use-package exec-path-from-shell
  :if (memq window-system '(x pgtk mac ns))
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

;;; ----------------------------------------------------------------------------
;;; Garbage collection (restore a sane threshold after the early-init bump)
;;; ----------------------------------------------------------------------------

(use-package gcmh
  :init (gcmh-mode 1)
  :config (setq gcmh-high-cons-threshold (* 128 1024 1024)))

;;; ----------------------------------------------------------------------------
;;; Sane defaults
;;; ----------------------------------------------------------------------------

(use-package emacs
  :ensure nil
  :init
  (setq-default indent-tabs-mode nil
                tab-width 4
                fill-column 88)              ; ruff/black default line length
  (setq make-backup-files nil
        create-lockfiles nil
        auto-save-default nil
        custom-file (expand-file-name "custom.el" user-emacs-directory)
        ring-bell-function 'ignore
        use-short-answers t
        sentence-end-double-space nil
        require-final-newline t
        completion-ignore-case t
        read-extended-command-predicate #'command-completion-default-include-p)
  :config
  (load custom-file 'noerror)
  (column-number-mode 1)
  (global-display-line-numbers-mode 1)
  (setq display-line-numbers-type 'relative)
  (delete-selection-mode 1)
  (global-auto-revert-mode 1)
  (savehist-mode 1)                          ; persist minibuffer history
  (recentf-mode 1)
  (electric-pair-mode 1)
  (show-paren-mode 1)
  ;; Treat each underscore-separated word as a subword (handy for snake_case).
  (global-subword-mode 1))

;;; ----------------------------------------------------------------------------
;;; Tree-sitter: auto-install grammars and remap *-mode -> *-ts-mode
;;; ----------------------------------------------------------------------------

(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode)
  ;; Declare grammar sources explicitly so they can be installed
  ;; non-interactively with M-x treesit-install-language-grammar (and so the
  ;; Python grammar is guaranteed present rather than prompted on first open).
  (dolist (src '((python     "https://github.com/tree-sitter/tree-sitter-python")
                 (toml       "https://github.com/tree-sitter/tree-sitter-toml")
                 (json       "https://github.com/tree-sitter/tree-sitter-json")
                 (yaml       "https://github.com/ikatyang/tree-sitter-yaml")))
    (add-to-list 'treesit-language-source-alist src))
  (unless (treesit-language-available-p 'python)
    (treesit-install-language-grammar 'python)))

;;; ----------------------------------------------------------------------------
;;; Minibuffer completion: vertico + orderless + marginalia + consult
;;; ----------------------------------------------------------------------------

(use-package vertico
  :init (vertico-mode)
  :custom (vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))
                                   (eglot (styles orderless))
                                   (eglot-capf (styles orderless)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s"   . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("M-s r" . consult-ripgrep)))

;;; ----------------------------------------------------------------------------
;;; In-buffer completion: corfu + cape
;;; ----------------------------------------------------------------------------

(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)                 ; popup automatically as you type
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :config
  ;; The doc side-panel also uses a child frame, so only in graphical Emacs.
  (when (display-graphic-p)
    (corfu-popupinfo-mode 1)))    ; show docs next to the candidate

;; Corfu draws its popup with child frames, which don't exist in a terminal
;; (emacs -nw / over SSH).  corfu-terminal re-renders the popup with overlays so
;; in-buffer completion works in the terminal too.
(use-package corfu-terminal
  :unless (display-graphic-p)
  :config (corfu-terminal-mode 1))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))

;;; ----------------------------------------------------------------------------
;;; Project niceties
;;; ----------------------------------------------------------------------------

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package which-key
  :ensure nil                    ; built in to Emacs 30
  :init (which-key-mode))

;;; ----------------------------------------------------------------------------
;;; LSP: eglot (built-in) + performance booster
;;; ----------------------------------------------------------------------------

(use-package eglot
  :ensure nil                    ; built in
  :hook ((python-base-mode . eglot-ensure))
  :custom
  ;; eldoc can be noisy with big docstrings; keep it to one line at echo area.
  (eglot-extend-to-xref t)
  :config
  ;; Try basedpyright first, then Astral's ty, then stock pyright.  Switch the
  ;; active server interactively with: M-x eglot-alternatives is implicit; just
  ;; restart eglot and pick from the prompt, or reorder this list.
  (add-to-list 'eglot-server-programs
               `(python-base-mode
                 . ,(eglot-alternatives
                     '(("basedpyright-langserver" "--stdio")
                       ("ty" "server")
                       ("pyright-langserver" "--stdio")))))
  ;; Don't let eglot take over formatting; we use ruff via reformatter below.
  (add-to-list 'eglot-ignored-server-capabilities :documentFormattingProvider)
  (add-to-list 'eglot-ignored-server-capabilities :documentRangeFormattingProvider))

;; Wrap the LSP server in emacs-lsp-booster for faster JSON-RPC.  No-op if the
;; binary isn't present.
(use-package eglot-booster
  :vc (:url "https://github.com/jdtsmith/eglot-booster" :rev :newest)
  :after eglot
  :config
  (when (executable-find "emacs-lsp-booster")
    (eglot-booster-mode)))

;;; ----------------------------------------------------------------------------
;;; Python: virtualenv detection, formatting, mode tweaks
;;; ----------------------------------------------------------------------------

;; pet = Python Executable Tracker.  Finds the right per-project virtualenv
;; (.venv, uv.lock, pyproject.toml, Pipfile, conda, ...) and points eglot,
;; flymake and the inferior shell at the correct binaries -- zero config.
(use-package pet
  :config
  ;; Wrap pet-mode in condition-case: if it errors (e.g. inotify exhaustion ->
  ;; "Too many open files" during file-watch setup), the error must NOT escape
  ;; the mode hook.  An unhandled error here aborts run-mode-hooks, which skips
  ;; both font-lock activation (after-change-major-mode-hook) and eglot-ensure,
  ;; leaving you with no highlighting and no LSP.
  (defun my/safe-pet-mode ()
    "Enable `pet-mode', but never let it error out of the mode hook."
    (condition-case err
        (pet-mode)
      (error
       (message "[init] pet-mode disabled for this buffer: %s"
                (error-message-string err)))))
  ;; Run early (depth -10) so buffer-local executables are set before
  ;; eglot-ensure starts the server.
  (add-hook 'python-base-mode-hook #'my/safe-pet-mode -10))

;; ruff for formatting + import sorting.  ruff can't format and sort imports in
;; a single invocation, so we define two reformatters and run both on save.
(use-package reformatter
  :config
  (reformatter-define ruff-format
    :program "ruff"
    :args `("format" "--stdin-filename" ,(or (buffer-file-name) input-file) "-"))
  (reformatter-define ruff-isort
    :program "ruff"
    :args `("check" "--select" "I" "--fix" "--quiet"
            "--stdin-filename" ,(or (buffer-file-name) input-file) "-"))
  (defun my/python-format-on-save ()
    "Sort imports then format the current Python buffer with ruff."
    (when (derived-mode-p 'python-base-mode)
      (ruff-isort-buffer)
      (ruff-format-buffer)))
  (add-hook 'python-base-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'my/python-format-on-save nil t))))

(use-package python
  :ensure nil
  :custom
  (python-shell-interpreter "python")
  (python-indent-guess-indent-offset-verbose nil)
  :config
  ;; Send code to a REPL with C-c C-c / C-c C-r as usual; these are defaults but
  ;; documented here for discoverability.
  (setq python-indent-offset 4)
  ;; The inferior shell's "native" readline completion injects terminal control
  ;; characters into the prompt over SSH/terminal Emacs, polluting your input.
  ;; Disable it; the (non-native) fallback completion still works.
  (setq python-shell-completion-native-enable nil)
  ;; Don't let corfu auto-pop its menu while you type at the REPL -- it fights
  ;; with interactive input.  Manual completion (M-x completion-at-point) still
  ;; works in the shell.
  (add-hook 'inferior-python-mode-hook
            (lambda () (setq-local corfu-auto nil))))

;;; ----------------------------------------------------------------------------
;;; AI assistance: Claude Code (IDE / MCP integration)
;;; ----------------------------------------------------------------------------
;; claude-code-ide.el bridges the Claude Code CLI (`claude', already on
;; ~/.local/bin and thus exec-path) into Emacs over Claude Code's IDE/MCP
;; protocol.  Beyond running the TUI in a terminal buffer it gives you:
;;   * ediff review of Claude's edits, inside Emacs
;;   * Flymake/Flycheck diagnostics shared with Claude
;;   * the active region / current buffer sent as context, file @-mentions
;;   * xref / imenu / tree-sitter / project tools exposed back to Claude
;; Sessions are keyed per-project via project.el.  Not on MELPA yet, so it is
;; pinned from git via :vc (same mechanism as eglot-booster above).

;; Terminal backend.  claude-code-ide can drive vterm, eat, or ghostel; vterm
;; would need to native-compile libvterm (cmake + libtool, neither installed
;; here), whereas eat is pure elisp and needs no build step.  eat ships on
;; NonGnu ELPA, which is already in `package-archives'.
(use-package eat
  :ensure t)

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c a" . claude-code-ide-menu)   ; transient: start / resume / send / ...
  :init
  (setq claude-code-ide-terminal-backend 'eat
        ;; SECURITY: the executeCode MCP tool lets Claude `eval' arbitrary elisp
        ;; in this live session.  Upstream defaults this to t; keep it OFF.  The
        ;; read-only editor tools enabled below (xref/imenu/treesit/project/
        ;; diagnostics) are unaffected.
        claude-code-ide-enable-execute-code nil)
  :config
  ;; Register the navigation/analysis MCP tools (no code-execution tool here).
  (claude-code-ide-emacs-tools-setup))

;;; ----------------------------------------------------------------------------
;;; Theme & UI polish
;;; ----------------------------------------------------------------------------

;; Modus themes ship with Emacs 30 and are built for accessibility (WCAG AAA
;; contrast).  The *-deuteranopia variants remap red/green semantics (errors vs
;; success, diff add/remove, the completion-selection highlight) to blue/yellow,
;; which stay distinguishable with red-green color blindness.
;;   * dark : modus-vivendi-deuteranopia
;;   * light: modus-operandi-deuteranopia
;; Switch anytime with M-x modus-themes-toggle.
(use-package modus-themes
  :ensure t                ; the bundled build lacks the modus-themes library/toggle
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-to-toggle '(modus-operandi-deuteranopia
                                 modus-vivendi-deuteranopia))
  :config
  (load-theme 'modus-vivendi-deuteranopia :no-confirm))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-buffer-encoding nil))

(provide 'init)
;;; init.el ends here
