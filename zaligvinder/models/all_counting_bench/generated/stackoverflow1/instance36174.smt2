;test regex regmatches(x, regexpr('\\b[A-Z ]{2,}\\b', x))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "x") (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (re.++ (re.* (re.union (re.range "A" "Z") (str.to_re " "))) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (str.to_re " ")))) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (str.to_re "\u{27}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "x"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)