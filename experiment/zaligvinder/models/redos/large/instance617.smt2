;test regex [a-f0-9]{60,}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.union (re.range "a" "f") (re.range "0" "9"))) ((_ re.loop 60 60) (re.union (re.range "a" "f") (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)