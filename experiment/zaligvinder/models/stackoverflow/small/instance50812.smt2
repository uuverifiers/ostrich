;test regex ^[0-9]{7}@burnswin\.edu\.au\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (str.to_re "@") (re.++ (str.to_re "b") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re ".") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "u") (re.++ (str.to_re ".") (re.++ (str.to_re "a") (re.++ (str.to_re "u") (str.to_re "z")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)