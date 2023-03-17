;test regex I[A-Z]{3}_\d{5}-\d_\d{8}_\d{8}_\d{6}\.zip
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "z") (re.++ (str.to_re "i") (str.to_re "p"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)