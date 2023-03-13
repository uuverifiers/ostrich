;test regex ^(XI|YV|XD|YQ|XZ){1}\d+Z{0,1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (re.++ (str.to_re "X") (str.to_re "I")) (re.++ (str.to_re "Y") (str.to_re "V"))) (re.++ (str.to_re "X") (str.to_re "D"))) (re.++ (str.to_re "Y") (str.to_re "Q"))) (re.++ (str.to_re "X") (str.to_re "Z")))) (re.++ (re.+ (re.range "0" "9")) ((_ re.loop 0 1) (str.to_re "Z"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)