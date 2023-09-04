;test regex \A/images/email.[a-f0-9]{32}.png\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (str.to_re "z")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)