;test regex ^(FL3)20([0-9]{2})([0-9]{2})([0-9]{5})$|^S[XNS][42][10][0]-([0-9]{2})([0-9]{2})([0-9]{2})-[0-9]{4}$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "F") (re.++ (str.to_re "L") (str.to_re "3"))) (re.++ (str.to_re "20") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "S") (re.++ (re.union (str.to_re "X") (re.union (str.to_re "N") (str.to_re "S"))) (re.++ (str.to_re "42") (re.++ (str.to_re "10") (re.++ (str.to_re "0") (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))))))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)