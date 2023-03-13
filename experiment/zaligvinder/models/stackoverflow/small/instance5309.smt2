;test regex \r\n[0-9]{3,15}(.*\r\n[0-9]{1,3})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ ((_ re.loop 3 15) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 3) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)