;test regex (EP \d{5,7})(?:.*[\r\n]+){52}.*$1
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "E") (re.++ (str.to_re "P") (re.++ (str.to_re " ") ((_ re.loop 5 7) (re.range "0" "9"))))) (re.++ ((_ re.loop 52 52) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))) (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "") (str.to_re "1")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)