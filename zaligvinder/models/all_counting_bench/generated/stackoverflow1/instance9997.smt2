;test regex ^(?:/[a-z]+){3}\.pdf$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.++ (str.to_re "/") (re.+ (re.range "a" "z")))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)