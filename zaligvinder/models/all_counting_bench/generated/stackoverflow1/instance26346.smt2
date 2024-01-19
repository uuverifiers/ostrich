;test regex String PHONE_PATTERN = "^(?:(?:00|\+)\d{2}|0)[1-9](?:\d{8})$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "P") (re.++ (str.to_re "H") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ (str.to_re "E") (re.++ (str.to_re "_") (re.++ (str.to_re "P") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "N") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{22}")))))))))))))))))))))))) (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.union (str.to_re "00") (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "0")) (re.++ (re.range "1" "9") ((_ re.loop 8 8) (re.range "0" "9")))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)