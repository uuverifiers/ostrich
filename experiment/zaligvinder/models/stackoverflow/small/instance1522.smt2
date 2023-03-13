;test regex (([A-Z0-9]{5}--)|([A-Z0-9]{6}-))[0-9]{3}[A-Z]{2}65[0-9ABCDEF]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "-") (str.to_re "-"))) (re.++ ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (str.to_re "65") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "E") (str.to_re "F"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)