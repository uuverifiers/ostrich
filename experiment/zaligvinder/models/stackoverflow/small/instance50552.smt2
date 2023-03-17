;test regex ^(181[2-9]|18[2-9]\d|19\d\d|2\d{3}|30[0-3]\d|304[0-8])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "181") (re.range "2" "9")) (re.++ (str.to_re "18") (re.++ (re.range "2" "9") (re.range "0" "9")))) (re.++ (str.to_re "19") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "2") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "30") (re.++ (re.range "0" "3") (re.range "0" "9")))) (re.++ (str.to_re "304") (re.range "0" "8")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)