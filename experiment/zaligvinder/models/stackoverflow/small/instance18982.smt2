;test regex ^89410[1|2]000[0-9]{10}|893207000[0-9]{10}$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "89410") (re.++ (re.union (str.to_re "1") (re.union (str.to_re "|") (str.to_re "2"))) (re.++ (str.to_re "000") ((_ re.loop 10 10) (re.range "0" "9")))))) (re.++ (re.++ (str.to_re "893207000") ((_ re.loop 10 10) (re.range "0" "9"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)