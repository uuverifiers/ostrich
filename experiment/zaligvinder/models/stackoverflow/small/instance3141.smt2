;test regex (070|071|072|073|074|075|076|077|078|079)\d{7,8}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "070") (str.to_re "071")) (str.to_re "072")) (str.to_re "073")) (str.to_re "074")) (str.to_re "075")) (str.to_re "076")) (str.to_re "077")) (str.to_re "078")) (str.to_re "079")) ((_ re.loop 7 8) (re.range "0" "9"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)