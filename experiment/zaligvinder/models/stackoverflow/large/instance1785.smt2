;test regex '.{75}(George\\sBush|Barack\\sObama).{75}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 75 75) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "G") (re.++ (str.to_re "e") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (str.to_re "B") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (str.to_re "h")))))))))))) (re.++ (str.to_re "B") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (str.to_re "O") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "a")))))))))))))) (re.++ ((_ re.loop 75 75) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{27}")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)