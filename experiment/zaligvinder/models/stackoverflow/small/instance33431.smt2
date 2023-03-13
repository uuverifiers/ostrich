;test regex ^(01)(12345678)(\d{5})\d(11|17)(\d{2}[0-1]\d[0-3]\d)(10|21)(\d{1,20})(30)(\d{1,20})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "01") (re.++ (str.to_re "12345678") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "0" "9") (re.++ (re.union (str.to_re "11") (str.to_re "17")) (re.++ (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.range "0" "1") (re.++ (re.range "0" "9") (re.++ (re.range "0" "3") (re.range "0" "9"))))) (re.++ (re.union (str.to_re "10") (str.to_re "21")) (re.++ ((_ re.loop 1 20) (re.range "0" "9")) (re.++ (str.to_re "30") ((_ re.loop 1 20) (re.range "0" "9"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)