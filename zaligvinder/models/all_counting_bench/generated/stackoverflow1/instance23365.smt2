;test regex ^(PERSON|PEOPLE)-[0-9]{1,}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "P") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "S") (re.++ (str.to_re "O") (str.to_re "N")))))) (re.++ (str.to_re "P") (re.++ (str.to_re "E") (re.++ (str.to_re "O") (re.++ (str.to_re "P") (re.++ (str.to_re "L") (str.to_re "E"))))))) (re.++ (str.to_re "-") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)