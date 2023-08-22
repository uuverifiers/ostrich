;test regex ^6(?:011\d{12}|5\d{14}|4[4-9]\d{13}|22(?:1(?:2[6-9]|[3-9]\d)|[2-8]\d{2}|9(?:[01]\d|2[0-5]))\d{10})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "6") (re.union (re.union (re.union (re.++ (str.to_re "011") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "5") ((_ re.loop 14 14) (re.range "0" "9")))) (re.++ (str.to_re "4") (re.++ (re.range "4" "9") ((_ re.loop 13 13) (re.range "0" "9"))))) (re.++ (str.to_re "22") (re.++ (re.union (re.union (re.++ (str.to_re "1") (re.union (re.++ (str.to_re "2") (re.range "6" "9")) (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (re.range "2" "8") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "9") (re.union (re.++ (str.to_re "01") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "5"))))) ((_ re.loop 10 10) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)