;test regex (LIF |LPA)\d{1,2}(.\d{1,2})*(\.\d{1})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "F") (str.to_re " ")))) (re.++ (str.to_re "L") (re.++ (str.to_re "P") (str.to_re "A")))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.* (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 1 2) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)