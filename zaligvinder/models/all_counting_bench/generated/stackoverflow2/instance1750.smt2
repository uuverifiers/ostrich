;test regex \ATESTDATAMENDNOW[A-Z]{237}\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "D") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "A") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "D") (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "W") (re.++ ((_ re.loop 237 237) (re.range "A" "Z")) (str.to_re "z"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)