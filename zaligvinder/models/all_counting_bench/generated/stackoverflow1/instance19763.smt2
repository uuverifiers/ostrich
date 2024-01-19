;test regex ^(([123][1-9]|[234]0)[0-9]{3}|10([5-9][0-9]{2}|4([3-9][0-9]|29)))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.++ (str.to_re "123") (re.range "1" "9")) (re.++ (str.to_re "234") (str.to_re "0"))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "10") (re.union (re.++ (re.range "5" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "4") (re.union (re.++ (re.range "3" "9") (re.range "0" "9")) (str.to_re "29"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)