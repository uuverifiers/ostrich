;test regex air_temp": \K-?\d{1,2}\.\d{1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "r") (re.++ (str.to_re "_") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re "K") (re.++ (re.opt (str.to_re "-")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)