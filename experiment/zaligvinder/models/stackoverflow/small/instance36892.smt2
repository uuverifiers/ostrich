;test regex ^(\s{0,1}([0-9a-zA-Z]{2,5}):\s{0,1}){1,5}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") ((_ re.loop 1 5) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 2 5) (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re ":") ((_ re.loop 0 1) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)