;test regex ^(([a-zA-z0-9][A-Z0-9a-z-]{1,61}[a-zA-Z0-9][.])+[a-zA-Z0-9]+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "z") (re.range "0" "9"))) (re.++ ((_ re.loop 1 61) (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (re.range "a" "z") (str.to_re "-"))))) (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "."))))) (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)