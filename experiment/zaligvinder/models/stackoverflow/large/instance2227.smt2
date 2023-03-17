;test regex ^([a-z0-9]([a-z0-9-]*[a-z0-9])*){1,60}\.cz$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 60) (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (str.to_re "z"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)