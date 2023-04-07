;test regex Regex.Split(line, "[ ]{2,}").Length
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "S") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (re.++ (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "e")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (str.to_re " ")) ((_ re.loop 2 2) (str.to_re " "))) (str.to_re "\u{22}")))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "L") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re "t") (str.to_re "h")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)