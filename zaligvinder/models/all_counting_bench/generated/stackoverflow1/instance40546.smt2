;test regex \s*([A-Z]{1}([a-z]){2,15})(([-| von ]?[A-Z]{1}[a-z]{2,15})*?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 2 15) (re.range "a" "z"))) (re.* (re.++ (re.opt (re.union (str.to_re "-") (re.union (str.to_re "|") (re.union (str.to_re " ") (re.union (str.to_re "v") (re.union (str.to_re "o") (re.union (str.to_re "n") (str.to_re " ")))))))) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 2 15) (re.range "a" "z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)