;test regex ^(\d{3})(\d*)(\D)(\d*)((XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$)?(.*$)?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.* (re.range "0" "9")) (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (re.* (re.range "0" "9")) (re.++ (re.opt (re.++ (re.++ (re.union (re.union (re.++ (str.to_re "X") (str.to_re "C")) (re.++ (str.to_re "X") (str.to_re "L"))) (re.++ (re.opt (str.to_re "L")) ((_ re.loop 0 3) (str.to_re "X")))) (re.union (re.union (re.++ (str.to_re "I") (str.to_re "X")) (re.++ (str.to_re "I") (str.to_re "V"))) (re.++ (re.opt (str.to_re "V")) ((_ re.loop 0 3) (str.to_re "I"))))) (str.to_re ""))) (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)