;test regex 8000[0-9]{12}|4000[0-9]{12}|2000[0-9]{11}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "8000") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "4000") ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (str.to_re "2000") ((_ re.loop 11 11) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)