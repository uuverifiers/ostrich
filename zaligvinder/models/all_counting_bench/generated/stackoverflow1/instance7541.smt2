;test regex @"^NHCC-\d{5}-00$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ (str.to_re "N") (re.++ (str.to_re "H") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "-") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "-") (str.to_re "00")))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)