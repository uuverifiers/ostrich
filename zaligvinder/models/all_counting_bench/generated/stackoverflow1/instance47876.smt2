;test regex feed_([4-9][0-9]{4}|[1-9][0-9]{5,})\.txt
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "f") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "_") (re.++ (re.union (re.++ (re.range "4" "9") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))))) (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)