(setq elixir-dogma-packages
      '(flycheck
        (flycheck-elixir-dogma
         :location (recipe
                    :fetcher github
                    :repo "obmarg/flycheck-elixir-dogma"))))

(defun elixir-dogma/init-flycheck-elixir-dogma ()
  (use-package flycheck)
  (use-package flycheck-elixir-dogma
               :defer t
               :init (add-hook 'elixir-mode-hook 'flycheck-elixir-dogma-setup)))

(defun elixir-dogma/post-init-flycheck ()
  (add-hook 'elixir-mode-hook 'flycheck-mode))
