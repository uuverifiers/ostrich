;test regex token.*([a-z0-9]{32})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)