;test regex ^(KELECTRIC)\.(BNK)\.([0-9]{8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "I") (str.to_re "C"))))))))) (re.++ (str.to_re ".") (re.++ (re.++ (str.to_re "B") (re.++ (str.to_re "N") (str.to_re "K"))) (re.++ (str.to_re ".") ((_ re.loop 8 8) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)