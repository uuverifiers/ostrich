;test regex (?:9[0-4][0-9]{3}|[1-8][0-9]{4}|[1-9][0-9]{1,3}|[0-9])
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "9") (re.++ (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.range "1" "8") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (re.range "1" "9") ((_ re.loop 1 3) (re.range "0" "9")))) (re.range "0" "9"))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)