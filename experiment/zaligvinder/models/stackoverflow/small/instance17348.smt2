;test regex "{0}{1}" -f $prefix, $VMlist[0].Name
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ ((_ re.loop 1 1) ((_ re.loop 0 0) (str.to_re "\u{22}"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "f") (str.to_re " ")))))) (re.++ (str.to_re "") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (str.to_re "x")))))))) (re.++ (str.to_re ",") (str.to_re " "))) (re.++ (str.to_re "") (re.++ (str.to_re "V") (re.++ (str.to_re "M") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "0") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "N") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "e"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)