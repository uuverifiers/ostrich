;test regex 0\.\d+\.\d{14}\.[a-fA-F0-9]{7}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "0") (re.++ (str.to_re ".") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 14 14) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 7 7) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)