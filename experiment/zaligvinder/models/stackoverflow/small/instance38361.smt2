;test regex ^([+61|0](2|4|3|7|8|)){0,2}([ 0-9]|[(]){2,3}([)]|[0-9]){6}([ ])[0-9]{7,20}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 2) (re.++ (re.union (str.to_re "+") (re.union (str.to_re "61") (re.union (str.to_re "|") (str.to_re "0")))) (re.union (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (str.to_re "2") (str.to_re "4")) (str.to_re "3")) (str.to_re "7")) (str.to_re "8"))) (str.to_re "")))) (re.++ ((_ re.loop 2 3) (re.union (re.union (str.to_re " ") (re.range "0" "9")) (str.to_re "("))) (re.++ ((_ re.loop 6 6) (re.union (str.to_re ")") (re.range "0" "9"))) (re.++ (str.to_re " ") ((_ re.loop 7 20) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)