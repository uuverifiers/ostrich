;test regex Regex::Replace(text, "(6)", "${1}78");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "6") (str.to_re "\u{22}")))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "\u{22}")))) (re.++ ((_ re.loop 1 1) (str.to_re "")) (re.++ (str.to_re "78") (str.to_re "\u{22}")))) (str.to_re ";"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)