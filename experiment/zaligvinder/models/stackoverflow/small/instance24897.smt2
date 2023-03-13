;test regex (?:'?[a-z]){5,}|((?:'?[a-z]){4}'?)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.* (re.++ (re.opt (str.to_re "\u{27}")) (re.range "a" "z"))) ((_ re.loop 5 5) (re.++ (re.opt (str.to_re "\u{27}")) (re.range "a" "z")))) (re.++ ((_ re.loop 4 4) (re.++ (re.opt (str.to_re "\u{27}")) (re.range "a" "z"))) (re.opt (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)