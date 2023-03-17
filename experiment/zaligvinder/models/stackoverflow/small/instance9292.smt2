;test regex ^(\d{7}-\d|\d{6}[A-Z])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (str.to_re "-") (re.range "0" "9"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.range "A" "Z")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)