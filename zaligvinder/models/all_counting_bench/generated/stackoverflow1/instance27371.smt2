;test regex ^[A-Z][a-zA-Z]{3,}(?: [A-Z][a-zA-Z]*){0,2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 0 2) (re.++ (str.to_re " ") (re.++ (re.range "A" "Z") (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)