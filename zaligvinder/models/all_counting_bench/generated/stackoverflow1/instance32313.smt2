;test regex (.+?)\s?([a-z]?\d(?:\.\d){1,2}(?:-[a-z])?)?\s(abc|mnp)
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.opt (re.++ (re.opt (re.range "a" "z")) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 1 2) (re.++ (str.to_re ".") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "-") (re.range "a" "z"))))))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c"))) (re.++ (str.to_re "m") (re.++ (str.to_re "n") (str.to_re "p"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)