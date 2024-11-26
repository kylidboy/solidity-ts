;; -*- no-byte-compile: t; -*-
;;; lang/solidity/packages.el

(package! solidity-mode)
(package! solidity-ts-mode
  :recipe (:host github :repo "kylidboy/solidity-ts-mode"))

(when
    (and (modulep! :checkers syntax)
         (not (modulep! :checkers syntax +flymake)))
  (package! solidity-flycheck))
