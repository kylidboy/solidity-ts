;;; lang/solidity/doctor.el -*- lexical-binding: t; -*-

(when (modulep! :tools lsp)
  (if (modulep! +eth-wake)
      (when (not (executable-find "wake"))
        (warn! "Couldn't find eth-wake. Install: pipx install eth-wake"))
    (when (not (executable-find "nomicfoundation-solidity-language-server"))
      (warn! "Couldn't find nomicfoundation-solidity-language-server. Install: npm install @nomicfoundation/solidity-language-server -g"))))

(when (not (executable-find "slither"))
  (warn! "Couldn't find slither. Highly recommend."))

(when (not (treesit-available-p))
  (warn! "Treesit is not available."))

(when (not (treesit-ready-p 'solidity))
  (warn! "Tree-sitter solidity parser is not available."))
