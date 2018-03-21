(setq mix-format-packages
      '((elixir-format :location (recipe
                                   :fetcher github
                                   :repo "obmarg/mix-format.el"))
        ))

(defun mix-format/init-elixir-format ()
  (use-package elixir-format
    :init (progn
            (spacemacs/set-leader-keys-for-major-mode 'elixir-mode
              "=" 'elixir-format)
            (setq elixir-format-mix-path "mix")
            (add-hook 'elixir-format-hook
                      '(lambda ()
                         (if (projectile-project-p)
                             (setq elixir-format-arguments
                                   (list "--dot-formatter"
                                         (concat (projectile-project-root) "/.formatter.exs")))
                           (setq elixir-format-arguments nil))))
            (add-hook 'elixir-mode-hook
                      (lambda () (add-hook 'before-save-hook elixir-format-before-save)))

            )))
