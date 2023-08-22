;test regex [1-9A-Z][0-9A-Z]{2}|0[1-9A-Z][0-9A-Z]|00[3-9A-Z]
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.union (re.range "1" "9") (re.range "A" "Z")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z")))) (re.++ (str.to_re "0") (re.++ (re.union (re.range "1" "9") (re.range "A" "Z")) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (str.to_re "00") (re.union (re.range "3" "9") (re.range "A" "Z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)