;test regex (23:59:59)|([01]{1}[0-9]|2[0-3]):((00)|(15)|(30)|(45))+:(00)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "23") (re.++ (str.to_re ":") (re.++ (str.to_re "59") (re.++ (str.to_re ":") (str.to_re "59"))))) (re.++ (re.union (re.++ ((_ re.loop 1 1) (str.to_re "01")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.++ (str.to_re ":") (re.++ (re.+ (re.union (re.union (re.union (str.to_re "00") (str.to_re "15")) (str.to_re "30")) (str.to_re "45"))) (re.++ (str.to_re ":") (str.to_re "00"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)