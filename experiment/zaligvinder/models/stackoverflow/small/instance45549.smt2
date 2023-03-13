;test regex GCAT[TGCA]{5,8}[TC]{7,10}G
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "G") (re.++ (str.to_re "C") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ ((_ re.loop 5 8) (re.union (str.to_re "T") (re.union (str.to_re "G") (re.union (str.to_re "C") (str.to_re "A"))))) (re.++ ((_ re.loop 7 10) (re.union (str.to_re "T") (str.to_re "C"))) (str.to_re "G")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)