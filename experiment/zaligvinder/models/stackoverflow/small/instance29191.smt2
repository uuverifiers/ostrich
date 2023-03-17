;test regex r"(2012|2013|2014)_(10|11)_\dproduptd\d{4}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.union (str.to_re "2012") (str.to_re "2013")) (str.to_re "2014")) (re.++ (str.to_re "_") (re.++ (re.union (str.to_re "10") (str.to_re "11")) (re.++ (str.to_re "_") (re.++ (re.range "0" "9") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (re.++ (str.to_re "u") (re.++ (str.to_re "p") (re.++ (str.to_re "t") (re.++ (str.to_re "d") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{22}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)