;test regex \\\w+_[2-9]\d{3}-[0-1]\d-[0-3]\d_[0-2]\d-[0-5]\d-[0-5]\d\.ext
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\\") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "_") (re.++ (re.range "2" "9") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.range "0" "1") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "3") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") (re.++ (re.range "0" "2") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "5") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "5") (re.++ (re.range "0" "9") (re.++ (str.to_re ".") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)