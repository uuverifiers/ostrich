;test regex /^\x{00}{2}GET /test/test.jpg$/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) ((_ re.loop 0 0) (str.to_re "x"))) (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "/") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))))))))))))))))))))) (re.++ (str.to_re "") (str.to_re "/")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)