;test regex [A-Z]{3}((1.*?[A-C]$)|(2.*?[D-F]$)|(3.*?[G-I]$))
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.union (re.union (re.++ (re.++ (str.to_re "1") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.range "A" "C"))) (str.to_re "")) (re.++ (re.++ (str.to_re "2") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.range "D" "F"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "3") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.range "G" "I"))) (str.to_re ""))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)