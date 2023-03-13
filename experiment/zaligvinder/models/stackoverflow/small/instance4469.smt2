;test regex " (IX|IV|V?I{0,3}|M{1,4}|CM|CD|D?C{1,3}|XC|XL|L?X{1,3})\."
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "I") (str.to_re "X")) (re.++ (str.to_re "I") (str.to_re "V"))) (re.++ (re.opt (str.to_re "V")) ((_ re.loop 0 3) (str.to_re "I")))) ((_ re.loop 1 4) (str.to_re "M"))) (re.++ (str.to_re "C") (str.to_re "M"))) (re.++ (str.to_re "C") (str.to_re "D"))) (re.++ (re.opt (str.to_re "D")) ((_ re.loop 1 3) (str.to_re "C")))) (re.++ (str.to_re "X") (str.to_re "C"))) (re.++ (str.to_re "X") (str.to_re "L"))) (re.++ (re.opt (str.to_re "L")) ((_ re.loop 1 3) (str.to_re "X")))) (re.++ (str.to_re ".") (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)