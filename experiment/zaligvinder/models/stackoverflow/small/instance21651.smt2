;test regex num_([a-z]{3,9})_([0-9]{2})_10p
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 9) (re.range "a" "z")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "10") (str.to_re "p"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)