;test regex (?:[a-z]{2,4}|museum|travel)
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 2 4) (re.range "a" "z")) (re.++ (str.to_re "m") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "u") (str.to_re "m"))))))) (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "l")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)