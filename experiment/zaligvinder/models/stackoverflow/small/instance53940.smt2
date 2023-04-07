;test regex ([\+|0](?:[0-9/\-\(\) ] ?){7,25}[0-9])
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "+") (re.union (str.to_re "|") (str.to_re "0"))) (re.++ ((_ re.loop 7 25) (re.++ (re.union (re.range "0" "9") (re.union (str.to_re "/") (re.union (str.to_re "-") (re.union (str.to_re "(") (re.union (str.to_re ")") (str.to_re " ")))))) (re.opt (str.to_re " ")))) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)