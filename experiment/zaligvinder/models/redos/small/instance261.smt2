;test regex ^[a-zA-Z0-9]([-._a-zA-Z0-9]{0,48}[a-zA-Z0-9])?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.opt (re.++ ((_ re.loop 0 48) (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)