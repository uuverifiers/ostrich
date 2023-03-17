;test regex ([a-zA-z]+)(\s)([a-zA-Z]+[a-zA-z0-9]+)(\({1})(.*)(\){1})(\n|\r)*(\{{1})(.|\n|\r)+(\}{1})[^\n]
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "z"))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "z") (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "(")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 1 1) (str.to_re ")")) (re.++ (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (re.++ ((_ re.loop 1 1) (str.to_re "{")) (re.++ (re.+ (re.union (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}")) (str.to_re "\u{0d}"))) (re.++ ((_ re.loop 1 1) (str.to_re "}")) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)