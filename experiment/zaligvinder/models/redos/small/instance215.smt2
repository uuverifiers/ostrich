;test regex first-job\/[0-9a-f]{8}-[0-9a-f-]{27}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "r") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "-") (re.++ (str.to_re "j") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "/") (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") ((_ re.loop 27 27) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (str.to_re "-"))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)