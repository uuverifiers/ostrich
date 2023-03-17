;test regex '\d{1,4}[Rr]\d{0,3} | ([RKM]\d{3}) | (\d{4})'
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.union (str.to_re "R") (str.to_re "r")) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re " "))))) (re.++ (str.to_re " ") (re.++ (re.++ (re.union (str.to_re "R") (re.union (str.to_re "K") (str.to_re "M"))) ((_ re.loop 3 3) (re.range "0" "9"))) (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)