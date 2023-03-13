;test regex ^((\+971|00971){1}(2|3|4|6|7|9|50|51|52|55|56){1}([0-9]{7}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.++ (str.to_re "+") (str.to_re "971")) (str.to_re "00971"))) (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "2") (str.to_re "3")) (str.to_re "4")) (str.to_re "6")) (str.to_re "7")) (str.to_re "9")) (str.to_re "50")) (str.to_re "51")) (str.to_re "52")) (str.to_re "55")) (str.to_re "56"))) ((_ re.loop 7 7) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)