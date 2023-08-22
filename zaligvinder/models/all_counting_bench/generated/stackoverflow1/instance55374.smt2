;test regex ^(50|51|53|57|60|66|69|72|73|78|79|88)\d{7}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "50") (str.to_re "51")) (str.to_re "53")) (str.to_re "57")) (str.to_re "60")) (str.to_re "66")) (str.to_re "69")) (str.to_re "72")) (str.to_re "73")) (str.to_re "78")) (str.to_re "79")) (str.to_re "88")) ((_ re.loop 7 7) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)