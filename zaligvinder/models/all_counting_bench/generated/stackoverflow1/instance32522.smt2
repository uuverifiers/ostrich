;test regex '^(6011|622(12[6-9]|1[3-9][0-9]|[2-8][0-9]{2}|9[0-1][0-9]|92[0-5]|64[4-9])|65)'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "") (re.++ (re.union (re.union (str.to_re "6011") (re.++ (str.to_re "622") (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "12") (re.range "6" "9")) (re.++ (str.to_re "1") (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (re.range "2" "8") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "9") (re.++ (re.range "0" "1") (re.range "0" "9")))) (re.++ (str.to_re "92") (re.range "0" "5"))) (re.++ (str.to_re "64") (re.range "4" "9"))))) (str.to_re "65")) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)