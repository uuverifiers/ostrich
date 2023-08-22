;test regex ^Register: 0x[0-9A-F]{4} = 0x([0-9A-F]{4})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "0") (re.++ (str.to_re "x") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)