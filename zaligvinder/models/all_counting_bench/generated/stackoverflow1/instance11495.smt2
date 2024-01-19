;test regex (^FOO[0-9]{4})|(^BAR[0-9]{3})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "F") (re.++ (str.to_re "O") (re.++ (str.to_re "O") ((_ re.loop 4 4) (re.range "0" "9")))))) (re.++ (str.to_re "") (re.++ (str.to_re "B") (re.++ (str.to_re "A") (re.++ (str.to_re "R") ((_ re.loop 3 3) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)