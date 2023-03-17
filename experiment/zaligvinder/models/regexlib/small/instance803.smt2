;test regex ^([A-HJ-TP-Z]{1}\d{4}[A-Z]{3}|[a-z]{1}\d{4}[a-hj-tp-z]{3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "H") (re.union (re.range "J" "T") (re.range "P" "Z")))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "A" "Z")))) (re.++ ((_ re.loop 1 1) (re.range "a" "z")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "a" "h") (re.union (re.range "j" "t") (re.range "p" "z")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)