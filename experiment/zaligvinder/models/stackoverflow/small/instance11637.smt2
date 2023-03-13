;test regex (AS|NL|MH  etc).*?(\d{2}).*?([A-Z]{2}).*?(\d{4})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "A") (str.to_re "S")) (re.++ (str.to_re "N") (str.to_re "L"))) (re.++ (str.to_re "M") (re.++ (str.to_re "H") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (str.to_re "c")))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 4 4) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)