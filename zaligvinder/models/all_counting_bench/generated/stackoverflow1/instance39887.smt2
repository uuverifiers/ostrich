;test regex ^[0]{1}([0-6,8-9]{10,11}|[7]{11})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (str.to_re "0")) (re.union ((_ re.loop 10 11) (re.union (re.range "0" "6") (re.union (str.to_re ",") (re.range "8" "9")))) ((_ re.loop 11 11) (str.to_re "7"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)