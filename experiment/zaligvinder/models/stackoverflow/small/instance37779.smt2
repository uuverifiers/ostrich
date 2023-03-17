;test regex Save The Children (Donation)|10.00{0}{2}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "S") (re.++ (str.to_re "a") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "T") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "C") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "d") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "D") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (str.to_re "n")))))))))))))))))))))))))) (re.++ (str.to_re "10") (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 2) ((_ re.loop 0 0) (str.to_re "00"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)