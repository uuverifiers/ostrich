;test regex (\\+237|237)\" \"(6|2)(2|3|[5-9])[0-9]{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.+ (str.to_re "\\")) (str.to_re "237")) (str.to_re "237")) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.union (str.to_re "6") (str.to_re "2")) (re.++ (re.union (re.union (str.to_re "2") (str.to_re "3")) (re.range "5" "9")) ((_ re.loop 7 7) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)