; ----
; language
; ----
;; set language as Japanese
(set-language-environment 'Japanese)
;; coding UTF8
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)

(leaf ddskk
      :ensure t
      :bind (("C-x C-j" . skk-mode))
      :init
      (defvar dired-bind-jump nil)
      :custom
      (skk-egg-like-newline . t))
(leaf treesit
  :config
  (setopt treesit-font-lock-level 4)
)
