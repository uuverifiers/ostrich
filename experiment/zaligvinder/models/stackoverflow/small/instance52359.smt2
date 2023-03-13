;test regex 0(x|X)(\d|[a-fA-F]){1,};
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "0") (re.++ (re.union (str.to_re "x") (str.to_re "X")) (re.++ (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))) (str.to_re ";"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)