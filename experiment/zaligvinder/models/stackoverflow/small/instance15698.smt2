;test regex (\d{2}-\d{2})\r\n(\d{2}-\d{2})\r\n(.*)\r\n(.*)\r\n(\d+(?:,?\d+))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (re.+ (re.range "0" "9")) (re.++ (re.opt (str.to_re ",")) (re.+ (re.range "0" "9"))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)