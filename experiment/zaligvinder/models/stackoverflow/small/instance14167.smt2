;test regex ^\d{0,3}/(ADD\.|MOD\.)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.++ (str.to_re "/") (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "D") (re.++ (str.to_re "D") (str.to_re ".")))) (re.++ (str.to_re "M") (re.++ (str.to_re "O") (re.++ (str.to_re "D") (str.to_re "."))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)