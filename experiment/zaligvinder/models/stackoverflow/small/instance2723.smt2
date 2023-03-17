;test regex .{5}-hello[.]file|.{4}-hello-unasigned[.]file
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re ".") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e")))))))))))) (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "-") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re ".") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)