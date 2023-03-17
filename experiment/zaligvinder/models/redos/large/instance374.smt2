;test regex ^[1-9a-km-zA-HJ-NP-Z]{1,111}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 1 111) (re.union (re.range "1" "9") (re.union (re.range "a" "k") (re.union (re.range "m" "z") (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.range "P" "Z")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)