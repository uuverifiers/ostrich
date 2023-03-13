;test regex (ATG(?:A{3}|C{3}|G{3}|T{3})(?:TAA|TAG|TGA))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "G") (re.++ (re.union (re.union (re.union ((_ re.loop 3 3) (str.to_re "A")) ((_ re.loop 3 3) (str.to_re "C"))) ((_ re.loop 3 3) (str.to_re "G"))) ((_ re.loop 3 3) (str.to_re "T"))) (re.union (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "A"))) (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "G")))) (re.++ (str.to_re "T") (re.++ (str.to_re "G") (str.to_re "A"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)