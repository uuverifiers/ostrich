;test regex ^[A-Z][-'a-zA-Z]+,?\s[A-Z][-'a-zA-Z]{0,19}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.+ (re.union (str.to_re "-") (re.union (str.to_re "\u{27}") (re.union (re.range "a" "z") (re.range "A" "Z"))))))) (re.++ (re.opt (str.to_re ",")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.range "A" "Z") ((_ re.loop 0 19) (re.union (str.to_re "-") (re.union (str.to_re "\u{27}") (re.union (re.range "a" "z") (re.range "A" "Z"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)