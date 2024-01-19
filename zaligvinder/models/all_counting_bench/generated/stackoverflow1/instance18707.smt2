;test regex ^[a-z]+\s[a-z]+,\s[a-z]{3}\d{1,2}-prt-([a-z]+-){0,1}\d{1,3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.range "a" "z")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.+ (re.range "a" "z"))))) (re.++ (str.to_re ",") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (re.++ (str.to_re "-") (re.++ ((_ re.loop 0 1) (re.++ (re.+ (re.range "a" "z")) (str.to_re "-"))) ((_ re.loop 1 3) (re.range "0" "9"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)