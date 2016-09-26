(setq py-isort-packages
      '(py-isort))

(defun py-isort/init-py-isort ()
  (use-package py-isort
    :init (add-hook 'before-save-hook 'py-isort-before-save)))
