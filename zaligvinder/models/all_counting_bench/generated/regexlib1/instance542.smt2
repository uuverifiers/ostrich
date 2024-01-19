;test regex ^[0-9]{8}R[A-HJ-NP-TV-Z]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "R") (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (re.range "P" "T") (re.range "V" "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)