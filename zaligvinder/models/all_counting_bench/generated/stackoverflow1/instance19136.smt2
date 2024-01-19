;test regex (0? [0-9]{2})? 9 [6-8] [0-9]{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "0")) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re " ") (re.++ (str.to_re "9") (re.++ (str.to_re " ") (re.++ (re.range "6" "8") (re.++ (str.to_re " ") ((_ re.loop 7 7) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)