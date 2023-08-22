;test regex ([a-zA-Z]+)\.([0-9]{4}[0-9]{2}[0-9]{2})\.(xls|pdf)\.pgp
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re ".") (re.++ (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (re.union (re.++ (str.to_re "x") (re.++ (str.to_re "l") (str.to_re "s"))) (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "g") (str.to_re "p")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)