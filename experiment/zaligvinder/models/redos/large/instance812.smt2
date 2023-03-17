;test regex ^(-0x|0x)?[0-9a-fA-F]{64}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.union (re.++ (str.to_re "-") (re.++ (str.to_re "0") (str.to_re "x"))) (re.++ (str.to_re "0") (str.to_re "x")))) ((_ re.loop 64 64) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)