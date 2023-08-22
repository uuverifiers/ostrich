;test regex [a-z]{2}\.mydomain\.xx
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re ".") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re ".") (re.++ (str.to_re "x") (str.to_re "x")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)