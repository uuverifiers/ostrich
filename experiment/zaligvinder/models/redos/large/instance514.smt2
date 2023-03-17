;test regex [1-9a-km-zA-LMNP-Z]{51,111}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 51 111) (re.union (re.range "1" "9") (re.union (re.range "a" "k") (re.union (re.range "m" "z") (re.union (re.range "A" "L") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.range "P" "Z"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)