;test regex ^UWU\/(CST|IIT)\/\d{2}\/\d{4,}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "U") (re.++ (str.to_re "W") (re.++ (str.to_re "U") (re.++ (str.to_re "/") (re.++ (re.union (re.++ (str.to_re "C") (re.++ (str.to_re "S") (str.to_re "T"))) (re.++ (str.to_re "I") (re.++ (str.to_re "I") (str.to_re "T")))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)