(setq hjson-post-extensions
      '(hjson-mode
        flycheck-hjson))

(defun hjson/init-hjson-mode ()
  (use-package hjson-mode))

(defun hjson/init-flycheck-hjson ()
  (use-package flycheck-hjson
    :init (spacemacs/add-flycheck-hook 'hjson-mode-hook)))
