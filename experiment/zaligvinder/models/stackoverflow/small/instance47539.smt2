;test regex "(FFF1|FFF3){4,}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (re.union (re.++ (str.to_re "F") (re.++ (str.to_re "F") (re.++ (str.to_re "F") (str.to_re "1")))) (re.++ (str.to_re "F") (re.++ (str.to_re "F") (re.++ (str.to_re "F") (str.to_re "3")))))) ((_ re.loop 4 4) (re.union (re.++ (str.to_re "F") (re.++ (str.to_re "F") (re.++ (str.to_re "F") (str.to_re "1")))) (re.++ (str.to_re "F") (re.++ (str.to_re "F") (re.++ (str.to_re "F") (str.to_re "3"))))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)