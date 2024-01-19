;test regex boost::regex myRegex(R"(^(([a-z0-9_]{1,80})\/([a-z0-9_]{1,80})([?])){1,256}$)");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "b") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.++ (str.to_re "") ((_ re.loop 1 256) (re.++ ((_ re.loop 1 80) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 80) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "?")))))) (str.to_re "")) (str.to_re "\u{22}")))) (str.to_re ";"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)