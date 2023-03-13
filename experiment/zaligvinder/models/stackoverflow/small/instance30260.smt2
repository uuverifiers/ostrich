;test regex ^(\(0\d\)\d{7}|\(02\d\)\d{6,8}|0800\s\d{5,8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "(") (re.++ (str.to_re "0") (re.++ (re.range "0" "9") (re.++ (str.to_re ")") ((_ re.loop 7 7) (re.range "0" "9")))))) (re.++ (str.to_re "(") (re.++ (str.to_re "02") (re.++ (re.range "0" "9") (re.++ (str.to_re ")") ((_ re.loop 6 8) (re.range "0" "9"))))))) (re.++ (str.to_re "0800") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 5 8) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)