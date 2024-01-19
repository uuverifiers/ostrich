;test regex 2034{345}1245
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 345 345) (str.to_re "2034")) (str.to_re "1245"))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)