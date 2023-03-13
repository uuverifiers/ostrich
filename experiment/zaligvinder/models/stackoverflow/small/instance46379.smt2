;test regex ^CDFSDDRC\d{3}Curr\d{6}\.xls$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "C") (re.++ (str.to_re "D") (re.++ (str.to_re "F") (re.++ (str.to_re "S") (re.++ (str.to_re "D") (re.++ (str.to_re "D") (re.++ (str.to_re "R") (re.++ (str.to_re "C") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "C") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "r") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "x") (re.++ (str.to_re "l") (str.to_re "s"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)