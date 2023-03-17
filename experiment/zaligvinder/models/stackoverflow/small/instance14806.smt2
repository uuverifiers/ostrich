;test regex (?:[a-z]\d[a-z]{2}|\d[a-z]{3}|[a-z]{2}\d[a-z]|[a-z]{3}\d)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.range "a" "z") (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "a" "z")))) (re.++ (re.range "0" "9") ((_ re.loop 3 3) (re.range "a" "z")))) (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (re.range "0" "9") (re.range "a" "z")))) (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)