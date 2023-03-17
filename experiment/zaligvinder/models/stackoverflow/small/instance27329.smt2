;test regex ^3[1-3]*1{2,}[1-3]*2$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "3") (re.++ (re.* (re.range "1" "3")) (re.++ (re.++ (re.* (str.to_re "1")) ((_ re.loop 2 2) (str.to_re "1"))) (re.++ (re.* (re.range "1" "3")) (str.to_re "2")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)