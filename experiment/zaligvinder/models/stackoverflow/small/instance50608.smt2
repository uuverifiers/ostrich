;test regex ^(\w{2,5}[FGHJKMNQUVXZ])(\d)-(\w{2,5}[FGHJKMNQUVXZ])(\d)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.union (str.to_re "F") (re.union (str.to_re "G") (re.union (str.to_re "H") (re.union (str.to_re "J") (re.union (str.to_re "K") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.union (str.to_re "Q") (re.union (str.to_re "U") (re.union (str.to_re "V") (re.union (str.to_re "X") (str.to_re "Z"))))))))))))) (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.++ ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.union (str.to_re "F") (re.union (str.to_re "G") (re.union (str.to_re "H") (re.union (str.to_re "J") (re.union (str.to_re "K") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.union (str.to_re "Q") (re.union (str.to_re "U") (re.union (str.to_re "V") (re.union (str.to_re "X") (str.to_re "Z"))))))))))))) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)