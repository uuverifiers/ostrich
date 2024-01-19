;test regex egrep '(a.*){5,}' $FILE
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (re.++ (re.* (re.++ (str.to_re "a") (re.* (re.diff re.allchar (str.to_re "\n"))))) ((_ re.loop 5 5) (re.++ (str.to_re "a") (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re "\u{27}") (str.to_re " ")))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "F") (re.++ (str.to_re "I") (re.++ (str.to_re "L") (str.to_re "E"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)