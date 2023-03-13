;test regex (.*?(?:[AWMS\d]{2})[A-Z]{2}[\dA-Za-z]{1,3})
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "A") (re.union (str.to_re "W") (re.union (str.to_re "M") (re.union (str.to_re "S") (re.range "0" "9")))))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)