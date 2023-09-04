;test regex ^(6334[5-9]([0-9]{11}|[0-9]{13,14}))|(6767([0-9]{12}|[0-9]{14,15}))$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "6334") (re.++ (re.range "5" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 14) (re.range "0" "9")))))) (re.++ (re.++ (str.to_re "6767") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 14 15) (re.range "0" "9")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)