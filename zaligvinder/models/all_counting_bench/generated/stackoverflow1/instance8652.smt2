;test regex gsub("([^\\\\n])(\\s{1})?", "\\1", S1, perl=TRUE)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.inter (re.diff re.allchar (str.to_re "\\")) (re.inter (re.diff re.allchar (str.to_re "\\")) (re.diff re.allchar (str.to_re "n")))) (re.++ (re.opt (re.++ (str.to_re "\\") ((_ re.loop 1 1) (str.to_re "s")))) (str.to_re "\u{22}")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (str.to_re "\u{22}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (str.to_re "1"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re "=") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "U") (str.to_re "E"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)