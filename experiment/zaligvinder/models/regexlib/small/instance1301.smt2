;test regex ^(?:(?:\(|)0|\+27|27)(?:1[12345678]|2[123478]|3[1234569]|4[\d]|5[134678])(?:\) | |-|)\d{3}(?: |-|)\d{4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (re.union (re.++ (str.to_re "") (str.to_re "(")) (str.to_re "")) (str.to_re "0")) (re.++ (str.to_re "+") (str.to_re "27"))) (str.to_re "27")) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "1") (str.to_re "12345678")) (re.++ (str.to_re "2") (str.to_re "123478"))) (re.++ (str.to_re "3") (str.to_re "1234569"))) (re.++ (str.to_re "4") (re.range "0" "9"))) (re.++ (str.to_re "5") (str.to_re "134678"))) (re.++ (re.union (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re ")") (str.to_re " ")) (str.to_re " ")) (str.to_re "-"))) (str.to_re "")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.union (re.++ (str.to_re "") (re.union (str.to_re " ") (str.to_re "-"))) (str.to_re "")) ((_ re.loop 4 4) (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)