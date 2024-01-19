;test regex [a-z0-9A-Z-\s*]{1,80}\.(docx|doc|excel|ppt)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 80) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.union (str.to_re "-") (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (str.to_re "*"))))))) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (str.to_re "x")))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (str.to_re "c")))) (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (str.to_re "l")))))) (re.++ (str.to_re "p") (re.++ (str.to_re "p") (str.to_re "t"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)