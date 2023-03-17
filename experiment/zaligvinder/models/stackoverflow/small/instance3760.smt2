;test regex "^937[0-9]{0,11}$|7[0-9]{0,9}$"
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "937") ((_ re.loop 0 11) (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "7") ((_ re.loop 0 9) (re.range "0" "9"))) (re.++ (str.to_re "") (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)