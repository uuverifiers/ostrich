;test regex (A{3,}|B{3,}|C{3,}|...|Z{3,}|a{3,}|b{3,}|...|z{3,})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (re.* (str.to_re "A")) ((_ re.loop 3 3) (str.to_re "A"))) (re.++ (re.* (str.to_re "B")) ((_ re.loop 3 3) (str.to_re "B")))) (re.++ (re.* (str.to_re "C")) ((_ re.loop 3 3) (str.to_re "C")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.* (str.to_re "Z")) ((_ re.loop 3 3) (str.to_re "Z")))) (re.++ (re.* (str.to_re "a")) ((_ re.loop 3 3) (str.to_re "a")))) (re.++ (re.* (str.to_re "b")) ((_ re.loop 3 3) (str.to_re "b")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.* (str.to_re "z")) ((_ re.loop 3 3) (str.to_re "z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)