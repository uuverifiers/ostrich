;test regex ^0x[a-f0-9]{4}[a-f0-9]{16}[a-f0-9]{64}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) ((_ re.loop 64 64) (re.union (re.range "a" "f") (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)