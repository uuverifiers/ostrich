;test regex Date\((\d{10})(\d{3})([\+\-]\d{4})?\)\
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "(") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re ")") (str.to_re "\"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)