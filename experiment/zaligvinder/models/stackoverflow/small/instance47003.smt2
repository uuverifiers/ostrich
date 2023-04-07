;test regex [A-Za-z0-9]{6,20}$
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 6 20) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)