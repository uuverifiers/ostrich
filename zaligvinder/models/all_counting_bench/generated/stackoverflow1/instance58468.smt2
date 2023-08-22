;test regex "((^G0{0,2}$)|(^T|^R0{0,2}$))+"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "G") ((_ re.loop 0 2) (str.to_re "0")))) (str.to_re "")) (re.union (re.++ (str.to_re "") (str.to_re "T")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "R") ((_ re.loop 0 2) (str.to_re "0")))) (str.to_re ""))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)