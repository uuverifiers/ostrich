;test regex ,\\"\d{1,3}(,\d{3,3})*\squestions?\\",
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re ",") (re.++ (str.to_re "\\") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "q") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "\\") (str.to_re "\u{22}"))))))))))))))))) (str.to_re ","))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)