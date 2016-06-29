(setq toggle-test-packages
      '(toggle-test))

(defun toggle-test/init-toggle-test ()
  (use-package toggle-test
    :defer t
    :init
    (progn
      (spacemacs/set-leader-keys "fa" 'tgt-toggle))))
