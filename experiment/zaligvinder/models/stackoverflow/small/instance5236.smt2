;test regex RegularExpression(@"^.{8,}$")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)