;test regex \AGB([0-9]{9}|[0-9]{12}|(HA|GD)[0-9]{3})\Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "G") (re.++ (str.to_re "B") (re.++ (re.union (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (re.union (re.++ (str.to_re "H") (str.to_re "A")) (re.++ (str.to_re "G") (str.to_re "D"))) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "Z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)