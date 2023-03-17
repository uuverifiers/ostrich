;test regex findstr /R b.{12}m@e.{6}\.com c:\*.*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "m") (re.++ (str.to_re "@") (re.++ (str.to_re "e") (re.++ ((_ re.loop 6 6) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re ":") (re.++ (str.to_re "*") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)