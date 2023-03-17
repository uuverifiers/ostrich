;test regex "p_d\d{1,8}_t\d{1,8}_images\.ext_0"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "p") (re.++ (str.to_re "_") (re.++ (str.to_re "d") (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "t") (re.++ ((_ re.loop 1 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re ".") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "_") (re.++ (str.to_re "0") (str.to_re "\u{22}"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)