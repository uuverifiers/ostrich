;test regex ^(?:[0-2][0-9]{2}\\.[0-9]{2}|3(?:[0-5][0-9]\\.[0-9]{2}|60\\.00))[LR]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.range "0" "2") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (str.to_re "3") (re.union (re.++ (re.range "0" "5") (re.++ (re.range "0" "9") (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (str.to_re "60") (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "00"))))))) (re.union (str.to_re "L") (str.to_re "R")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)