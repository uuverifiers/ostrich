;test regex gsub("((?:\\S+\\s+){2})", "\\1* ", x, perl=T)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "S")) (re.++ (str.to_re "\\") (re.+ (str.to_re "s")))))) (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "1")) (re.++ (str.to_re " ") (str.to_re "\u{22}")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "x")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re "=") (str.to_re "T")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)