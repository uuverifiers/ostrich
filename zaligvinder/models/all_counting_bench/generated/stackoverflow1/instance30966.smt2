;test regex val regex = "((AB|BCC|CDD)|[A-Z]{2,4})-".r
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "B")) (re.++ (str.to_re "B") (re.++ (str.to_re "C") (str.to_re "C")))) (re.++ (str.to_re "C") (re.++ (str.to_re "D") (str.to_re "D")))) ((_ re.loop 2 4) (re.range "A" "Z"))) (re.++ (str.to_re "-") (re.++ (str.to_re "\u{22}") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "r"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)