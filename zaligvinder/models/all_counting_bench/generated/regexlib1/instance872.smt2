;test regex ^\d{8,8}$|^[SC]{2,2}\d{6,6}$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") ((_ re.loop 8 8) (re.range "0" "9"))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.union (str.to_re "S") (str.to_re "C"))) ((_ re.loop 6 6) (re.range "0" "9")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)