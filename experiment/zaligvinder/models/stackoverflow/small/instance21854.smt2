;test regex "GGAGG(.{5,13}?)(ATG|GTG|TTG)(...)+?(TGA|TAA|TAG)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "G") (re.++ (str.to_re "G") (re.++ (str.to_re "A") (re.++ (str.to_re "G") (re.++ (str.to_re "G") (re.++ ((_ re.loop 5 13) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "T") (str.to_re "G"))) (re.++ (str.to_re "G") (re.++ (str.to_re "T") (str.to_re "G")))) (re.++ (str.to_re "T") (re.++ (str.to_re "T") (str.to_re "G")))) (re.++ (re.+ (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.union (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "G") (str.to_re "A"))) (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "A")))) (re.++ (str.to_re "T") (re.++ (str.to_re "A") (str.to_re "G")))) (str.to_re "\u{22}")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)