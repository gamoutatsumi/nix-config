; ----
; language
; ----
;; set language as Japanese
(set-language-environment 'Japanese)
;; coding UTF8
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)

(leaf ddskk
      :bind (("C-x C-j" . skk-mode))
      :init
      (defvar dired-bind-jump nil)
      :custom
      (skk-egg-like-newline . t))
(leaf treesit
  :config
  (setopt treesit-font-lock-level 4))
(leaf org
      :require t)
(leaf leaf-tree)
(leaf leaf-convert )
(leaf modus-themes
      :require t
      :config
       (modus-themes-load-theme 'modus-vivendi)
      :custom
      `((modus-themes-bold-constructs . nil)
        (modus-themes-italic-constructs . t)))

(leaf lsp-mode
      :require t)

(leaf go-mode
      :require t)

(leaf bind-key
      :require t)

(leaf htmlize
      :require t)

(defvar user/standard-fontset
  (create-fontset-from-fontset-spec standard-fontset-spec)
  "Standard fontset for user.")
(defvar user/font-size 16
  "Default font size in px.")
(defvar user/cjk-font "HackGen Nerd" "Default font for CJK characters.")
(defvar user/latin-font "HackGen Nerd" "Default font for Latin characters.")
(defvar user/unicode-font "Noto Emoji" "Default font for Unicode characters, including emojis.")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(if window-system (progn
                    (require 'server)
                    (unless (server-running-p)
                      (server-start) )))

(if window-system (progn
                    (bind-key "C-x C-c" 'kill-this-buffer)
                    (when (equal system-type 'darwin)
                      (setq mac-option-modifier 'meta))))
(setq make-backup-files nil) 
