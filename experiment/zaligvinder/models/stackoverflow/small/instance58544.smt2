;test regex ^[*#]\d{4,6}$|^\d{4,6}[*#]$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "*") (str.to_re "#")) ((_ re.loop 4 6) (re.range "0" "9")))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 6) (re.range "0" "9")) (re.union (str.to_re "*") (str.to_re "#")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)