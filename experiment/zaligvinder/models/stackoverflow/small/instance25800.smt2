;test regex ^0*([5-9]|([1-9]\d{0,2})|([1-4]\d{3})|(50{3}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re "0")) (re.union (re.union (re.union (re.range "5" "9") (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (re.range "1" "4") ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 3 3) (str.to_re "50"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)