;test regex _[A-Za-z]{3}_[A-Za-z0-9]*_[A-Za-z0-9]*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re "_") (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re "_") (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)