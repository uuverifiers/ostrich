;test regex [IMG]{3}[0-9]{8}[_]?[a-zA-Z]?\.JPG
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (str.to_re "I") (re.union (str.to_re "M") (str.to_re "G")))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (re.opt (str.to_re "_")) (re.++ (re.opt (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re ".") (re.++ (str.to_re "J") (re.++ (str.to_re "P") (str.to_re "G"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)