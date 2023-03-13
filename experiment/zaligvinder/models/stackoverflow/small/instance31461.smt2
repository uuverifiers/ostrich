;test regex ^(?:ptno|PTNO)?0*\d{7,}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.union (re.++ (str.to_re "p") (re.++ (str.to_re "t") (re.++ (str.to_re "n") (str.to_re "o")))) (re.++ (str.to_re "P") (re.++ (str.to_re "T") (re.++ (str.to_re "N") (str.to_re "O")))))) (re.++ (re.* (str.to_re "0")) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 7 7) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)