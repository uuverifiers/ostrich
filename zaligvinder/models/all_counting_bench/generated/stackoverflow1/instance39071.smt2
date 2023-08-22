;test regex ^(?:\pL{2}|\pN{2})\pN{6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "p") ((_ re.loop 2 2) (str.to_re "L"))) (re.++ (str.to_re "p") ((_ re.loop 2 2) (str.to_re "N")))) (re.++ (str.to_re "p") ((_ re.loop 6 6) (str.to_re "N"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)