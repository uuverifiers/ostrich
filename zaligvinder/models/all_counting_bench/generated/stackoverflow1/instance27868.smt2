;test regex x{3}k|x{3}rb|x{3}\.x{4}|\d+
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ ((_ re.loop 3 3) (str.to_re "x")) (str.to_re "k")) (re.++ ((_ re.loop 3 3) (str.to_re "x")) (re.++ (str.to_re "r") (str.to_re "b")))) (re.++ ((_ re.loop 3 3) (str.to_re "x")) (re.++ (str.to_re ".") ((_ re.loop 4 4) (str.to_re "x"))))) (re.+ (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)