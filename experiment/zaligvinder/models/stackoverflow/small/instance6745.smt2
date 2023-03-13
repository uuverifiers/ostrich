;test regex ^(?:(?:(?:0|\+33)(?:6|7))\d{8}|0[67](?: \d{2}){4}|\+33 [67](?: \d{2}){4})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (re.++ (re.union (str.to_re "0") (re.++ (str.to_re "+") (str.to_re "33"))) (re.union (str.to_re "6") (str.to_re "7"))) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (str.to_re "0") (re.++ (str.to_re "67") ((_ re.loop 4 4) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))))))) (re.++ (str.to_re "+") (re.++ (str.to_re "33") (re.++ (str.to_re " ") (re.++ (str.to_re "67") ((_ re.loop 4 4) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)