;test regex ^{7,12}[1-9]{2,12}[A-Z0-9]{1,12}'
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 7 12) (str.to_re "")) (re.++ ((_ re.loop 2 12) (re.range "1" "9")) (re.++ ((_ re.loop 1 12) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)