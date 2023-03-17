;test regex ^T12F8B0A22[A-Z0-9]{2}F8$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "T") (re.++ (str.to_re "12") (re.++ (str.to_re "F") (re.++ (str.to_re "8") (re.++ (str.to_re "B") (re.++ (str.to_re "0") (re.++ (str.to_re "A") (re.++ (str.to_re "22") (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "F") (str.to_re "8")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)