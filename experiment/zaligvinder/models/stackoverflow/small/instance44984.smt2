;test regex <id>{1}</id> <Name>{2}</Name> <Detail>{3}</Detail>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ ((_ re.loop 1 1) (str.to_re ">")) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re ">") (re.++ (str.to_re " ") (re.++ (str.to_re "<") (re.++ (str.to_re "N") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ ((_ re.loop 2 2) (str.to_re ">")) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "N") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re ">") (re.++ (str.to_re " ") (re.++ (str.to_re "<") (re.++ (str.to_re "D") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ ((_ re.loop 3 3) (str.to_re ">")) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "D") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re ">")))))))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)