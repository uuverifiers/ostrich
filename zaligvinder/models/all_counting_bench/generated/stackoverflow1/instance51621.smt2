;test regex ^([B-Z][A-Z]*|A[A-LNOQ-Z]?|A[A-Z]{2,})_[A-Z_]+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (re.range "B" "Z") (re.* (re.range "A" "Z"))) (re.++ (str.to_re "A") (re.opt (re.union (re.range "A" "L") (re.union (str.to_re "N") (re.union (str.to_re "O") (re.range "Q" "Z"))))))) (re.++ (str.to_re "A") (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "A" "Z"))))) (re.++ (str.to_re "_") (re.+ (re.union (re.range "A" "Z") (str.to_re "_")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)