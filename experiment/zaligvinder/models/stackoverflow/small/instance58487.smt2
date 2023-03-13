;test regex ^[0-9]{1,6}(/([IXCDVML]+)|([0-9]+))?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 6) (re.range "0" "9")) (re.opt (re.union (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "I") (re.union (str.to_re "X") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "V") (re.union (str.to_re "M") (str.to_re "L"))))))))) (re.+ (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)