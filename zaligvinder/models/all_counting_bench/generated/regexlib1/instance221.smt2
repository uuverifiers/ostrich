;test regex ^(NT|SD2|S?(0T|D[01]|BR|K[1-9][0-9]{0,5}|[1-9][0-9]{0,5}[LMNT]))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "N") (str.to_re "T")) (re.++ (str.to_re "S") (re.++ (str.to_re "D") (str.to_re "2")))) (re.++ (re.opt (str.to_re "S")) (re.union (re.union (re.union (re.union (re.++ (str.to_re "0") (str.to_re "T")) (re.++ (str.to_re "D") (str.to_re "01"))) (re.++ (str.to_re "B") (str.to_re "R"))) (re.++ (str.to_re "K") (re.++ (re.range "1" "9") ((_ re.loop 0 5) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "N") (str.to_re "T")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)