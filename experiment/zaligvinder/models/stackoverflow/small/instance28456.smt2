;test regex Xal_Yal_Zal_[0-9]+-[0-9]{8}-[0-9]{9}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "X") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "_") (re.++ (str.to_re "Y") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "_") (re.++ (str.to_re "Z") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "_") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 9 9) (re.range "0" "9")))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)