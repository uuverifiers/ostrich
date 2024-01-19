;test regex ^XE[0-9]{2}(ETH[0-9A-Z]{13}|[0-9A-Z]{30,31})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "X") (re.++ (str.to_re "E") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "E") (re.++ (str.to_re "T") (re.++ (str.to_re "H") ((_ re.loop 13 13) (re.union (re.range "0" "9") (re.range "A" "Z")))))) ((_ re.loop 30 31) (re.union (re.range "0" "9") (re.range "A" "Z")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)