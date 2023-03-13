;test regex ^([a-z]{2}[a-z]?)[(P|G)(.*)]?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.opt (re.range "a" "z"))) (re.opt (re.union (str.to_re "(") (re.union (str.to_re "P") (re.union (str.to_re "|") (re.union (str.to_re "G") (re.union (str.to_re ")") (re.union (str.to_re "(") (re.union (str.to_re ".") (re.union (str.to_re "*") (str.to_re ")"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)