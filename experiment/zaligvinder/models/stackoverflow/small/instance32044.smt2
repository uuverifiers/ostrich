;test regex 0*(1[1-9][0-9]|[2-9][0-9]{2}|1[0-9]{3}|2[01][0-9]{2}|22[0-2][0-9]|223[0-4])
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (str.to_re "0")) (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "1") (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "1") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (str.to_re "01") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "22") (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (str.to_re "223") (re.range "0" "4"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)