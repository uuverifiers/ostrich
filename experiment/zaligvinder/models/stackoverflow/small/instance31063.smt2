;test regex ^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "b") (re.++ (str.to_re "c") (str.to_re "1"))) (str.to_re "13")) ((_ re.loop 25 39) (re.union (re.range "a" "z") (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (re.range "P" "Z") (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)