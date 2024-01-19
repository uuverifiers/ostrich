;test regex sed "s/[0-9A-F]{8}-[0-9]{4}-[0-9]{4}-[0-9A-F]{4}-[0-9A-F]{12}//g"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)