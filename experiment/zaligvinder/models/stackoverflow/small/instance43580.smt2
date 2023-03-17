;test regex 2009-(?:03-(?:0[2-9]|[1-9]\d)|(?:0[4-9]|1\d)-\d\d)|(?:20[1-9]\d|2[1-9]\d\d|[3-9]\d{3})-\d\d-\d\d
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "2009") (re.++ (str.to_re "-") (re.union (re.++ (str.to_re "03") (re.++ (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "2" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "4" "9")) (re.++ (str.to_re "1") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.range "0" "9"))))))) (re.++ (re.union (re.union (re.++ (str.to_re "20") (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.++ (str.to_re "2") (re.++ (re.range "1" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (re.range "3" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)