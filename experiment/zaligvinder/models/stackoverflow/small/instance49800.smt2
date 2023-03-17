;test regex ^[1-9][0-9]{3}|1[0-9]{4}|20000$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "1") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "20000") (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)