;test regex (?:^5[1-5]\d{14}$)|(?:^2(?:2(?:2[1-9]|[3-9]\d)\d{2}|[3-6]\d{4}|7(?:[01]\d{3}|20\d{2}))\d{10}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (re.union (re.union (re.++ (str.to_re "2") (re.++ (re.union (re.++ (str.to_re "2") (re.range "1" "9")) (re.++ (re.range "3" "9") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.range "3" "6") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "7") (re.union (re.++ (str.to_re "01") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "20") ((_ re.loop 2 2) (re.range "0" "9")))))) ((_ re.loop 10 10) (re.range "0" "9"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)