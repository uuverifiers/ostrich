;test regex ^([a-hj-mp-z0-9]{9}[a-hj-mp-rtv-z0-9][a-hj-mp-z0-9]\d{6}|[a-hj-z0-9]{6,11}\d{5})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 9 9) (re.union (re.range "a" "h") (re.union (re.range "j" "m") (re.union (re.range "p" "z") (re.range "0" "9"))))) (re.++ (re.union (re.range "a" "h") (re.union (re.range "j" "m") (re.union (re.range "p" "r") (re.union (str.to_re "t") (re.union (re.range "v" "z") (re.range "0" "9")))))) (re.++ (re.union (re.range "a" "h") (re.union (re.range "j" "m") (re.union (re.range "p" "z") (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ ((_ re.loop 6 11) (re.union (re.range "a" "h") (re.union (re.range "j" "z") (re.range "0" "9")))) ((_ re.loop 5 5) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)