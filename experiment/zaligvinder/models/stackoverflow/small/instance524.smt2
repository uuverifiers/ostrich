;test regex "\\bCONCEPT\\b\\s[A-Z]{3}\\b"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ (str.to_re "C") (re.++ (str.to_re "E") (re.++ (str.to_re "P") (re.++ (str.to_re "T") (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)