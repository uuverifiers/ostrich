;test regex var='^([+|-]{0,1}[0-9][0-9]*)|(auto)|(max)$'
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "=") (str.to_re "\u{27}"))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 0 1) (re.union (str.to_re "+") (re.union (str.to_re "|") (str.to_re "-")))) (re.++ (re.range "0" "9") (re.* (re.range "0" "9")))))) (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (str.to_re "o"))))) (re.++ (re.++ (str.to_re "m") (re.++ (str.to_re "a") (str.to_re "x"))) (re.++ (str.to_re "") (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)