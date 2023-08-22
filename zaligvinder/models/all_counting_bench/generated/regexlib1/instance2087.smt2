;test regex ^(([1-9]{1})|([0-1][1-2])|(0[1-9])|([1][0-2])):([0-5][0-9])(([aA])|([pP]))[mM]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ (re.range "0" "1") (re.range "1" "2"))) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.++ (str.to_re ":") (re.++ (re.++ (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "p") (str.to_re "P"))) (re.union (str.to_re "m") (str.to_re "M"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)