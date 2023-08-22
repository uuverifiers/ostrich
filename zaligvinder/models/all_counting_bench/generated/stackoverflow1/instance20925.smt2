;test regex ${1}1$3extra_input="203001"$5/>
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ ((_ re.loop 1 1) (str.to_re "")) (str.to_re "1")) (re.++ (str.to_re "") (re.++ (str.to_re "3") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "_") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "203001") (str.to_re "\u{22}")))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "5") (re.++ (str.to_re "/") (str.to_re ">")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)