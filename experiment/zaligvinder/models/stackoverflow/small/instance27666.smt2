;test regex ^LINE ([1-9][0-9]{0,2}|1000) (MKT|TGT)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "1000")) (re.++ (str.to_re " ") (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "K") (str.to_re "T"))) (re.++ (str.to_re "T") (re.++ (str.to_re "G") (str.to_re "T")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)