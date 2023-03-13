;test regex [0-9]|[1-9][0-9]{1,2}|1[0-7][0-9]{2}|18[0-6][0-9]|187[0-9]
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.range "0" "9") (re.++ (re.range "1" "9") ((_ re.loop 1 2) (re.range "0" "9")))) (re.++ (str.to_re "1") (re.++ (re.range "0" "7") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "18") (re.++ (re.range "0" "6") (re.range "0" "9")))) (re.++ (str.to_re "187") (re.range "0" "9")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)