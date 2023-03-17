;test regex (?:5[01357]|6[069]|7[2389]|88)\d{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.++ (str.to_re "5") (str.to_re "01357")) (re.++ (str.to_re "6") (str.to_re "069"))) (re.++ (str.to_re "7") (str.to_re "2389"))) (str.to_re "88")) ((_ re.loop 7 7) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)