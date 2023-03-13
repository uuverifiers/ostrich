;test regex ^ABC-DEF-F1-\d{8}-\d{3}-\d{12}-[\dA-Z-]+_\d{4}_V1.DAT.gz$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "C") (re.++ (str.to_re "-") (re.++ (str.to_re "D") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.++ (str.to_re "-") (re.++ (str.to_re "F") (re.++ (str.to_re "1") (re.++ (str.to_re "-") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (str.to_re "-")))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "V") (re.++ (str.to_re "1") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "D") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "g") (str.to_re "z"))))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)