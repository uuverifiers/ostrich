;test regex \\d{1,4}\\u00A0\\s+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 4) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (str.to_re "u") (re.++ (str.to_re "00") (re.++ (str.to_re "A") (re.++ (str.to_re "0") (re.++ (str.to_re "\\") (re.+ (str.to_re "s"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)