;test regex ^(1|2|3)abc(\d{2,4})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (str.to_re "1") (str.to_re "2")) (str.to_re "3")) (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") ((_ re.loop 2 4) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)