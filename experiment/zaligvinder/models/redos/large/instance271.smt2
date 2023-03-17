;test regex ^(\$2[axy]|\$2)\$[0-9]{2}\$[a-z0-9\/.]{53}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "$") (re.++ (str.to_re "2") (re.union (str.to_re "a") (re.union (str.to_re "x") (str.to_re "y"))))) (re.++ (str.to_re "$") (str.to_re "2"))) (re.++ (str.to_re "$") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "$") ((_ re.loop 53 53) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "/") (str.to_re ".")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)