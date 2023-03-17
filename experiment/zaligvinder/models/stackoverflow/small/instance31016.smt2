;test regex ^\+375 \((17|29|33|44)\) [0-9]{3}-[0-9]{2}-[0-9]{2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "+") (re.++ (str.to_re "375") (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (re.union (re.union (re.union (str.to_re "17") (str.to_re "29")) (str.to_re "33")) (str.to_re "44")) (re.++ (str.to_re ")") (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)