;test regex "[0-9]{4,5}\.HK|HSI[A-Z][0-9]|HMH[A-Z][0-9]|HCEI[A-Z][0-9]|HCEI[A-Z][0-9]-[A-Z][0-9]"
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 4 5) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "H") (str.to_re "K"))))) (re.++ (str.to_re "H") (re.++ (str.to_re "S") (re.++ (str.to_re "I") (re.++ (re.range "A" "Z") (re.range "0" "9")))))) (re.++ (str.to_re "H") (re.++ (str.to_re "M") (re.++ (str.to_re "H") (re.++ (re.range "A" "Z") (re.range "0" "9")))))) (re.++ (str.to_re "H") (re.++ (str.to_re "C") (re.++ (str.to_re "E") (re.++ (str.to_re "I") (re.++ (re.range "A" "Z") (re.range "0" "9"))))))) (re.++ (str.to_re "H") (re.++ (str.to_re "C") (re.++ (str.to_re "E") (re.++ (str.to_re "I") (re.++ (re.range "A" "Z") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "A" "Z") (re.++ (re.range "0" "9") (str.to_re "\u{22}")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)