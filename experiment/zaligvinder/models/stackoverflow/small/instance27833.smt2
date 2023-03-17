;test regex <entry key="MOB.PATTERN">^(\\+91)?[789]\\d{9}$</entry>
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "<") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "y") (re.++ (str.to_re " ") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "y") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "M") (re.++ (str.to_re "O") (re.++ (str.to_re "B") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "P") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "N") (re.++ (str.to_re "\u{22}") (str.to_re ">"))))))))))))))))))))))))) (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.+ (str.to_re "\\")) (str.to_re "91"))) (re.++ (str.to_re "789") (re.++ (str.to_re "\\") ((_ re.loop 9 9) (str.to_re "d"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "y") (str.to_re ">"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)