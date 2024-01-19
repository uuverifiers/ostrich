;test regex QR[0-9]\.[0-9]_[A-Z0-9]{5}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "Q") (re.++ (str.to_re "R") (re.++ (re.range "0" "9") (re.++ (str.to_re ".") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)