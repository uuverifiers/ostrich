;test regex \d{12}-[AB]_ZZ\d{6}_[A-Z]{4}-[A-Z0-9]{12}_OUT\.pdf
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "A") (str.to_re "B")) (re.++ (str.to_re "_") (re.++ (str.to_re "Z") (re.++ (str.to_re "Z") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "_") (re.++ (str.to_re "O") (re.++ (str.to_re "U") (re.++ (str.to_re "T") (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)