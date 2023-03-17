;test regex ptn=r"^(M{0,3})(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3}$)"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "p") (re.++ (str.to_re "t") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "r") (str.to_re "\u{22}")))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 0 3) (str.to_re "M")) (re.++ (re.union (re.union (re.++ (str.to_re "C") (str.to_re "M")) (re.++ (str.to_re "C") (str.to_re "D"))) (re.++ (re.opt (str.to_re "D")) ((_ re.loop 0 3) (str.to_re "C")))) (re.++ (re.union (re.union (re.++ (str.to_re "X") (str.to_re "C")) (re.++ (str.to_re "X") (str.to_re "L"))) (re.++ (re.opt (str.to_re "L")) ((_ re.loop 0 3) (str.to_re "X")))) (re.++ (re.union (re.union (re.++ (str.to_re "I") (str.to_re "X")) (re.++ (str.to_re "I") (str.to_re "V"))) (re.++ (re.++ (re.opt (str.to_re "V")) ((_ re.loop 0 3) (str.to_re "I"))) (str.to_re ""))) (str.to_re "\u{22}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)