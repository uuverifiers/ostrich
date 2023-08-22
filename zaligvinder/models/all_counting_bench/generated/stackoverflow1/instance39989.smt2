;test regex ^(CAT|DOG)[0-9]{8}\.TXT$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "C") (re.++ (str.to_re "A") (str.to_re "T"))) (re.++ (str.to_re "D") (re.++ (str.to_re "O") (str.to_re "G")))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "T") (re.++ (str.to_re "X") (str.to_re "T"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)