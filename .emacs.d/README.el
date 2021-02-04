(setq-default user-full-name "Jefter Santiago Mares")
(setq-default user-mail-address "jefterrsantiago@gmail.com")

(load "~/.local/bin/private.el")

(setq confirm-kill-processes nil)
(setq-default transient-mark-mode t)
(setq-default visual-line-mode t)
(setq-default truncate-lines nil)
(setq-default cursor-type 'box)
(setq-default fill-column 78)
;; (setq-default sentence-end-double-space nil)
;; Enable maximum syntax highlighting wherever possible.
(setq-default global-font-lock-mode t)

;;	(fset 'yes-or-no-p 'y-or-n-p)
	(defalias 'yes-or-no-p 'y-or-n-p)

(setq-default tab-width 4)
(use-package smartparens
  :ensure t
  :config
  (sp-use-paredit-bindings)
  (add-hook 'prog-mode-hook #'smartparens-mode)
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET"))))

(setq inhibit-splash-screen t
	       initial-scratch-message nil
	       initial-major-mode 'org-mode)
(setq inhibit-startup-message t)

(setq kill-buffer-query-functions
	  (remq 'process-kill-buffer-query-function
			kill-buffer-query-functions))
;; smother scroll
(setq scroll-step            1
	  scroll-conservatively  10000
	  mouse-wheel-scroll-amount '(1 ((shift) . 1))
	  mouse-wheel-progressive-speed nil
	  mouse-wheel-follow-mouse 't)

;; insert new line whithout breaking
(defun insert-new-line-below ()
      "Add a new line below the current line"
      (interactive)
      (let ((oldpos (point)))
	(end-of-line)
	(newline-and-indent)))
(global-set-key (kbd "C-o") 'insert-new-line-below)

;; trash "custom-variables" goes to a file that is ignored
(setq custom-file "~/.emacs.d/custom.el")

;; backup disabled
(setq-default backup-inhibited t)
(setq-default create-lockfiles nil)
(setq-default make-backup-files nil)
(use-package real-auto-save
  :ensure t
  :demand t
  :config (setq real-auto-save-interval 10)
  :hook (prog-mode . real-auto-save-mode))

(use-package modus-operandi-theme)

(defun transparency (value)
      "Sets the transparency of the frame window. 0=transparent/100=opaque."
      (interactive "nTransparency Value 0 - 100 opaque:")
      (set-frame-parameter (selected-frame) 'alpha value))

(defun hrs/apply-theme ()
      "Apply my chosen theme and make frames just slightly transparent."
      (interactive)
      (load-theme 'modus-operandi t)
      (transparency 90))

(if (daemonp)
	(add-hook 'after-make-frame-functions
			      (lambda (frame)
				(with-selected-frame frame (hrs/apply-theme))))
      (hrs/apply-theme))

(add-to-list 'default-frame-alist '(font . "Inconsolata 12"))
;; https://emacs.stackexchange.com/q/45895
(set-face-attribute 'fixed-pitch nil :family "Inconsolata 12")
(use-package default-text-scale
  :demand t
  :hook (after-init . default-text-scale-mode))

(global-set-key (kbd "C-x C-j") 'font-lock-mode)

(use-package diff-hl
      :config
      (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
      (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode))

(require 'display-line-numbers)
       (defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
	 "Major modes on which to disable the linum mode, exempts them from global requirement"
      :group 'display-line-numbers
      :type 'list
      :version "green")
(defun display-lines-numbers--turn-on ()
      "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
      (if (and
	       (not (member major-mode display-line-numbers-exempt-modes))
	       (not (minibufferp)))
							      (display-line-numbers-mode)))

 (global-display-line-numbers-mode)

(set-face-attribute 'default nil :height 80)
(setq ring-bell-function 'ignore)
(global-set-key (kbd "<f5>") 'revert-buffer)
(set-language-environment "UTF-8")
(global-prettify-symbols-mode t)

;;(use-package delight)
;;(delight 'emacs-lisp-mode "Elisp" :major)
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(set-window-scroll-bars (minibuffer-window) nil nil)

(use-package rainbow-delimiters)
;; simple mode line
(use-package mood-line)
(mood-line-mode)

(global-prettify-symbols-mode t)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(require 'evil)
(evil-mode 1)

(defun my-reload-dir-locals-for-current-buffer ()
  "reload dir locals for the current buffer"
  (interactive)
  (let ((enable-local-variables :all))
	(hack-dir-local-variables-non-file-buffer)))

(defun my-reload-dir-locals-for-all-buffer-in-this-directory ()
  "For every buffer with the same `default-directory` as the
current buffer's, reload dir-locals."
  (interactive)
  (let ((dir default-directory))
	(dolist (buffer (buffer-list))
	  (with-current-buffer buffer
		(when (equal default-directory dir))
		(my-reload-dir-locals-for-current-buffer)))))

(use-package dired-open
      :config
      (setq dired-open-extensions
		'(("doc" . "openoffice4")
		      ("docx" . "openoffice4")
		      ("xopp" . "xournalpp")
		      ("gif" . "mirage")
		      ("jpeg" ."mirage")
		      ("jpg" . "mirage")
		      ("png" . "mirage")
		      ("mkv" . "mpv")
		      ("avi" . "mpv")
		      ("mov" . "mpv")
		      ("mp3" . "mpv")
		      ("mp4" . "mpv")
		      ("pdf" . "okular")
		      ("webm" . "mpv")
		      )))

(use-package dired-hide-dotfiles
	:config
	(dired-hide-dotfiles-mode)
	(define-key dired-mode-map "." 'dired-hide-dotfiles-mode))

(setq-default dired-listing-switches "-lhvA")
(add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1)))

(use-package swiper
      :ensure t
      :config
      (progn
	(ivy-mode 1)
	(setq ivy-use-virtual-buffers t)
	(global-set-key "\C-s" 'swiper)
	(global-set-key "\C-r" 'swiper)))

(use-package ace-window
  :ensure t
  :init
  (progn
	(global-set-key [remap other-window] 'ace-window)
	(custom-set-faces
	 '(aw-leading-char-face
	       ((t (:inherit ace-jump-face-foreground :height 2.0)))))
	))

(use-package try
  :ensure t
  :config
  (progn (global-set-key (kbd "C-x b") 'ivy-switch-buffer)))
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-display-style 'fancy)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq-default TeX-master nil)
(setq TeX-PDF-mode t)
(add-hook 'LateX-mode-hook (lambda () (latex-preview-pane-mode)))
(global-set-key (kbd "C-x l ") 'latex-preview-pane-mode)

(use-package auctex
  :hook ((latex-mode LaTeX-mode) . lsp)
  :config
  (add-to-list 'font-latex-math-environments "dmath"))
(use-package auctex-latexmk
  :after auctex
  :init
  (auctex-latexmk-setup))

;; tweaks
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
(setq org-ellipsis "⤵")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-window-setup 'current-window)
(add-to-list 'org-structure-template-alist
			 '("el" . "src emacs-lisp"))


(add-hook 'org-mode-hook 'auto-fill-mode)
(setq-default fill-column 79)
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)" "DROP(x!)"))
	  org-log-into-drawer t)


;; tasks magagement
(defun org-file-path (filename)
  " Return the absolute address of an org file, give its relative name"
  (concat (file-name-as-directory org-directory) filename))

(setq org-index-file (org-file-path "tasks.org"))
(setq org-archive-location
	  (concat (org-file-path "done-tasks.org") "::* From %s"))

;; copy the content out of the archive.org file and yank in the inbox.org
(setq org-agenda-files (list org-index-file))
										; mark  a todo as done and move it to an appropriate place in the archive.
(defun hrs/mark-done-and-archive ()
  " Mark the state of an org-mode item as DONE and archive it."
  (interactive)
  (org-todo 'done)
  (org-archive-subtree))
(global-set-key (kbd "C-c C-x C-s") 'hrs/mark-done-and-archive)
(setq org-log-done 'time)

;; capturing tasks
(setq org-capture-templates
	  '(("t" "Todo"
		 entry
		 (file+headline org-index-file "Inbox")
		 "* TODO %?\n")))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
(define-key global-map "\C-cc" 'org-capture)
(defun hrs/open-index-file ()
  "Open the master org TODO list."
  (interactive)
  (hrs/copy-tasks-from-inbox)
  (find-file org-index-file)
  (flycheck-mode -1)
  (end-of-buffer))
(global-set-key (kbd "C-c i") 'hrs/open-index-file)


;; displaying inline images
;; The joy of programming = https://joy.pm/post/2017-09-17-a_graphviz_primer/
(defun my/fix-inline-images ()
  (when org-inline-image-overlays
	(org-redisplay-inline-images)))

(add-hook 'org-babel-after-execute-hook 'my/fix-inline-images)
(setq-default org-image-actual-width 620)
;; exporting with org-mode
;; html
(setq org-html-postamble nil)
(setq browse-url-browse-function 'browse-url-generic
	  browse-url-generic-program "firefox")
(setenv "BROWSER" "firefox")
;; diagrams
(use-package graphviz-dot-mode
  :ensure t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

(use-package counsel
  :ensure t
  :config
  (progn
	(global-set-key "\M-x" 'counsel-M-x)
	(global-set-key (kbd "C-x C-f") 'counsel-find-file)))
;;     (use-package auto-complete
;;     :ensure t
;;       :init
;;	  (progn
;;		(ac-config-default)
;;	(global-auto-complete-mode t)))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'flycheck-mode)
  (set-face-underline 'flycheck-error '(:color "#dc322f" :style line))
  (set-face-underline 'flycheck-warning '(:color "#e5aa00" :style line))
  (set-face-underline 'flycheck-info '(:color "#268bd2" :style line)))

(use-package flymake
  :config
  (set-face-underline 'flymake-error '(:color "#dc322f" :style line))
  (set-face-underline 'flymake-warning '(:color "#e5aa00" :style line))
  (set-face-underline 'flymake-note '(:color "#268bd2" :style line)))

(use-package company
  :ensure t
  :demand t
  :config (setq company-tooltip-align-annotations t))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package flycheck-checkbashisms
  ;; We assume that shellcheck can handle this.
  :disabled t
  :hook (flycheck-mode . flycheck-checkbashisms-setup)
  :config
  ;; Check 'echo -n' usage
  (setq flycheck-checkbashisms-newline t)
  (setq flycheck-checkbashisms-posix t))

(use-package elcord
  :config
    (setq elcord-client-id '"714056771391717468")
	(setq elcord-refresh-rate 5)
	(setq elcord-use-major-mode-as-main-icon t)
  :init
  (elcord-mode))
