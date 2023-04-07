;test regex 12 \K( ?[0-9A-F]{2}){6}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "12") (re.++ (str.to_re " ") (re.++ (str.to_re "K") ((_ re.loop 6 6) (re.++ (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)