;test regex ^(([0-2]{0,1}[1-9]{1})|(3{0,1}[0-1]{0,1}))\.((0[1-9])|(1[0-2]))\.((19[0-9][0-9])|(20((0[0-9])|(1[0-7]))))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ ((_ re.loop 0 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ ((_ re.loop 0 1) (str.to_re "3")) ((_ re.loop 0 1) (re.range "0" "1")))) (re.++ (str.to_re ".") (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.++ (str.to_re ".") (re.union (re.++ (str.to_re "19") (re.++ (re.range "0" "9") (re.range "0" "9"))) (re.++ (str.to_re "20") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "7")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)