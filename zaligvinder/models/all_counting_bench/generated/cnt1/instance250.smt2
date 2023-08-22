;test regex __cfduid=([a-f0-9]{46})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "_") (re.++ (str.to_re "_") (re.++ (str.to_re "c") (re.++ (str.to_re "f") (re.++ (str.to_re "d") (re.++ (str.to_re "u") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") ((_ re.loop 46 46) (re.union (re.range "a" "f") (re.range "0" "9"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)