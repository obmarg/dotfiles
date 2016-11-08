(setq copy-code-packages
      '((copy-code :location local)
        ))

(defun copy-code/init-copy-code ()
  (use-package copy-code
    :init (progn
      (spacemacs/set-leader-keys
        "Cy" 'copy-code-as-rtf))))
