;test regex [infdca]{0,4}r[i][nf]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 4) (re.union (str.to_re "i") (re.union (str.to_re "n") (re.union (str.to_re "f") (re.union (str.to_re "d") (re.union (str.to_re "c") (str.to_re "a"))))))) (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.union (str.to_re "n") (str.to_re "f")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)