;test regex ^[A-CEGHJ-PR-TW-Z]{1}[A-CEGHJ-NPR-TW-Z]{1}[0-9]{6}[A-D]{1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "C") (re.union (str.to_re "E") (re.union (str.to_re "G") (re.union (str.to_re "H") (re.union (re.range "J" "P") (re.union (re.range "R" "T") (re.range "W" "Z")))))))) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "C") (re.union (str.to_re "E") (re.union (str.to_re "G") (re.union (str.to_re "H") (re.union (re.range "J" "N") (re.union (str.to_re "P") (re.union (re.range "R" "T") (re.range "W" "Z"))))))))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "D")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)