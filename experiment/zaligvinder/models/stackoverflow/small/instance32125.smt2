;test regex ([0-7][0-9]{4}) | (8[0-5][0-9]{3}) | (86[0-3][0-9]{2}) | (86400)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.++ (re.range "0" "7") ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "8") (re.++ (re.range "0" "5") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "86") (re.++ (re.range "0" "3") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re " ")))) (re.++ (str.to_re " ") (str.to_re "86400")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)