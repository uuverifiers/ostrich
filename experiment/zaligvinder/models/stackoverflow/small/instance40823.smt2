;test regex ((?:\D{0,}_)(\d(_\d)*)(.*))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.* (re.diff re.allchar (re.range "0" "9"))) ((_ re.loop 0 0) (re.diff re.allchar (re.range "0" "9")))) (str.to_re "_")) (re.++ (re.++ (re.range "0" "9") (re.* (re.++ (str.to_re "_") (re.range "0" "9")))) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)