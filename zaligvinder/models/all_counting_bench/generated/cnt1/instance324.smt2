;test regex d_array_example\/[0-9a-f]{24}\/edit
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "d") (re.++ (str.to_re "_") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (re.++ (str.to_re "_") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "/") (re.++ ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "/") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (str.to_re "t"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)