;test regex pattern='[0-9]{4}-[0-1][0-9]-[0-3][0-9] (1[012]|[1-9]):[0-5][0-9] (am|pm|AM|PM)'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.range "0" "1") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "3") (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ (re.union (re.++ (str.to_re "1") (str.to_re "012")) (re.range "1" "9")) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "a") (str.to_re "m")) (re.++ (str.to_re "p") (str.to_re "m"))) (re.++ (str.to_re "A") (str.to_re "M"))) (re.++ (str.to_re "P") (str.to_re "M"))) (str.to_re "\u{27}"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)