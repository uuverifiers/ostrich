;test regex ^((\+989)|(989)|(00989)|(09|9))([1|2|3][0-9]\d{7}$)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "+") (str.to_re "989")) (str.to_re "989")) (str.to_re "00989")) (re.union (str.to_re "09") (str.to_re "9"))) (re.++ (re.++ (re.union (str.to_re "1") (re.union (str.to_re "|") (re.union (str.to_re "2") (re.union (str.to_re "|") (str.to_re "3"))))) (re.++ (re.range "0" "9") ((_ re.loop 7 7) (re.range "0" "9")))) (str.to_re ""))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)