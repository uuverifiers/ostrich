;test regex ^(?:(?:(?:0[1-9]|[1-8]\d|9[0-4])(?:\d{3})?)|97[1-8]|98[4-9]|2[abAB])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "8") (re.range "0" "9"))) (re.++ (str.to_re "9") (re.range "0" "4"))) (re.opt ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "97") (re.range "1" "8"))) (re.++ (str.to_re "98") (re.range "4" "9"))) (re.++ (str.to_re "2") (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "A") (str.to_re "B"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)