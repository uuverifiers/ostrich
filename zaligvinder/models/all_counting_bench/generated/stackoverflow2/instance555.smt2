;test regex ((([a-zA-Z0-9]{1,63}|[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])\.){1,3}[a-zA-Z]{2,63})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.++ (re.union ((_ re.loop 1 63) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "-"))))) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))) (str.to_re "."))) ((_ re.loop 2 63) (re.union (re.range "a" "z") (re.range "A" "Z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)