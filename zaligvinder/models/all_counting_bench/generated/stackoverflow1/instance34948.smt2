;test regex ^([1-9]|10)(;([1-9]|10)){0,3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "1" "9") (str.to_re "10")) ((_ re.loop 0 3) (re.++ (str.to_re ";") (re.union (re.range "1" "9") (str.to_re "10")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)