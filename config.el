

(defun wake-lsp-command (port)
  (list (executable-find "wake") "--debug" "lsp" "--port" port))

(defun solidity-lsp-command (_a1)
  (list "nomicfoundation-solidity-language-server" "--stdio"))

(when (modulep! :tools lsp)
  (if (modulep! :tools lsp +eglot)
      (after! eglot
        (if (modulep! +eth-wake)
            (add-to-list 'eglot-server-programs '(solidity-ts-mode . ("wake" "--debug" "lsp" "--port" :autoport)))
          (add-to-list 'eglot-server-programs '(solidity-ts-mode . solidity-lsp-command))))
    (after! lsp-mode
      ;; (lsp-dependency 'solidity-language-server-wake
      ;;                 '(:system "wake"))
      (add-to-list 'lsp-language-id-configuration '(solidity-ts-mode . "solidity"))
      (when (modulep! +eth-wake)
        (lsp-register-client (make-lsp-client
                              :language-id 'solidity
                              ;; :add-on? t
                              :new-connection (lsp-tcp-connection #'wake-lsp-command)
                              :activation-fn (lsp-activate-on "solidity")
                              :priority 1000
                              :server-id 'solidity
                              :library-folders-fn (lambda (_workspace) '("/lib/" "/node_module/"))))

        (message "lsp-mode wake")))))

(use-package! solidity-mode)

(use-package! solidity-ts-mode
  :after (solidity-mode)
  :mode "\\.sol\\'"
  :config
  (add-to-list 'major-mode-remap-alist '(solidity-mode . solidity-ts-mode))
  (after! projectile
    (add-to-list 'projectile-project-root-files "foundry.toml"))
  (setq solidity-comment-style 'slash)
  (set-docsets! 'solidity-mode "Solidity")
  (when (modulep! +forge-fmt)
    (set-formatter! 'forge-fmt '("forge" "fmt" "-r" "-") :modes '(solidity-mode solidity-ts-mode)))
  (when (modulep! :tools lsp)
    (add-hook 'solidity-ts-mode-hook #'lsp!)
    (when (modulep! +forge-fmt)
      (setq-hook! 'solidity-ts-mode-hook +format-with-lsp nil))))
