(setq user-full-name ""
      user-mail-address "puang59@proton.me")

(setq display-line-numbers-type t)
;; Set the fancy splash image
(setq fancy-splash-image "~/.doom.d/emacsOld2.png")

;; Load custom file types
(add-to-list 'auto-mode-alist '("\\.txt\\'" . some-mode))

;; Set the default directory
(setq default-directory "~/")


(defun info-goto-from-command-help ()
  "Go to the Info node in the Emacs manual for the command currently being viewed in `help-mode'."
  (interactive)
  (when (eq 'describe-function (car help-xref-stack-item))
    (info-goto-emacs-command-node (cadr help-xref-stack-item))))

(define-key help-mode-map "i" 'info-goto-from-command-help)

(setq doom-theme 'doom-one)

(setq org-directory "~/org/")
(after! org
  (setq org-log-done 'time)
  ;;((setq org-log-done 'note))
)

(elcord-mode)

;; configure neotree
(map! :leader
      :desc "Toggle Neotree"
      :prefix "o"
      "n" #'neotree-toggle)

;; Git grep (SPC+g)
(map! :leader
      :desc "Counsel git grep"
      :n "g" #'counsel-git-grep)

(map! :leader
      (:prefix ("o" . "Open")
       :desc "Open Org Directory" "o" (lambda () (interactive) (find-file "~/org/"))))

(defun create-and-open-org-file ()
  (interactive)
  (let* ((directory (file-name-as-directory (expand-file-name "~/orgfiles")))
         (file-path (concat directory "newFile.org")))
    (cond
      ((file-exists-p file-path)
       (if (y-or-n-p "File already exists. Open it? ")
           (find-file file-path)
         (message "File creation aborted")))
      (t
       (find-file file-path)))))

(global-set-key (kbd "C-c o") 'create-and-open-org-file)

(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(add-to-list 'default-frame-alist '(alpha . 90))

(after! lsp
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("ccls"))
                    :major-modes '(c++-mode)
                    :server-id 'ccls)))

;; Set the path to the node executable
(setq doom-nodejs-env (expand-file-name "/usr/bin/node"))

;; Set the node interpreter for JavaScript files
(add-hook! 'js2-mode-hook
  (setq-local flycheck-javascript-eslint-executable doom-nodejs-env))

;; Configure prettier-js
(after! prettier-js
  (setq prettier-js-args '(
    "--single-quote" "true"
    "--trailing-comma" "all"
    "--tab-width" "2"
    "--print-width" "80"
  )))

;; Automatically format code on save
(add-hook 'before-save-hook #'prettier-js)

;; Load web mode for .astro files
(define-derived-mode astro-mode web-mode "astro")
(add-to-list 'auto-mode-alist '("\\.astro\\'" . astro-mode))

;; Ensure flycheck eslint works with astro-mode
(add-hook! 'astro-mode-hook
  (setq-local flycheck-javascript-eslint-executable doom-nodejs-env))

(map! :leader
      :desc "Open My Org File in Split Window"
      :n "o s" #'(lambda () (interactive) (find-file-other-window "/Users/puang59/org/notes/secondbrain.org")))

(map! :leader
      :desc "Open School Agenda"
      :n "o q" #'(lambda () (interactive) (find-file "/Users/puang59/org/Agendas/school/FALL23/schedule.org")))

(map! :leader
      :desc "Open Daily schedule"
      :n "o g" #'(lambda () (interactive) (find-file "/Users/puang59/org/Agendas/dailyAgenda.org")))

(map! :leader
      (:prefix ("o" . "Open")
       :desc "Open Org Directory" "o" (lambda () (interactive) (find-file "~/org/"))))

(use-package org-auto-tangle
  :ensure t
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(provide 'config)
