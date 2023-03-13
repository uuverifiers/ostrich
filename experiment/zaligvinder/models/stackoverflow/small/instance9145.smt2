;test regex ^[a-z]{6}[2-9a-z][0-9a-np-z]([a-z0-9]{3}|x{3})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 6 6) (re.range "a" "z")) (re.++ (re.union (re.range "2" "9") (re.range "a" "z")) (re.++ (re.union (re.range "0" "9") (re.union (re.range "a" "n") (re.range "p" "z"))) (re.opt (re.union ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 3 3) (str.to_re "x")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)