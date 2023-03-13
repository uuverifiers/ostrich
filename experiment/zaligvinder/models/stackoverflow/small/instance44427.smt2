;test regex \d+{10,11}|(\d+\-\d+){11,12}|(\d+\-\d+\-\d+){12,13}
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 10 11) (re.+ (re.range "0" "9"))) ((_ re.loop 11 12) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))))) ((_ re.loop 12 13) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "-") (re.+ (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)