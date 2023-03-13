;test regex '(g31|g32).*?(g21|g22){0}.*?(g11|g22)'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (re.union (re.++ (str.to_re "g") (str.to_re "31")) (re.++ (str.to_re "g") (str.to_re "32"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 0 0) (re.union (re.++ (str.to_re "g") (str.to_re "21")) (re.++ (str.to_re "g") (str.to_re "22")))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "g") (str.to_re "11")) (re.++ (str.to_re "g") (str.to_re "22"))) (str.to_re "\u{27}")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)