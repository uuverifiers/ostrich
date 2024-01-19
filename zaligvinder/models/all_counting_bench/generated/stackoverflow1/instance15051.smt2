;test regex "^([0-9]{9})_([A-Z]{5})_([0-9]{8})_(1_USA)$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 5 5) (re.range "A" "Z")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "1") (re.++ (str.to_re "_") (re.++ (str.to_re "U") (re.++ (str.to_re "S") (str.to_re "A"))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)