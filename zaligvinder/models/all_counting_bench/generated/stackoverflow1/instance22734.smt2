;test regex [B-DF-HJ-NP-TV-XZ]{2,10}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 10) (re.union (re.range "B" "D") (re.union (re.range "F" "H") (re.union (re.range "J" "N") (re.union (re.range "P" "T") (re.union (re.range "V" "X") (str.to_re "Z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)