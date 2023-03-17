;test regex String regExPhone = "(\+91(-)?|91(-)?|0(-)?)?[0-9]{10}";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "P") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.opt (re.union (re.union (re.++ (str.to_re "+") (re.++ (str.to_re "91") (re.opt (str.to_re "-")))) (re.++ (str.to_re "91") (re.opt (str.to_re "-")))) (re.++ (str.to_re "0") (re.opt (str.to_re "-"))))) (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)