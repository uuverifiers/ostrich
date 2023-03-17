;test regex ^([BPXT][0-9]{6})|([a-zA-Z][a-zA-z][0-9][0-9](adm)?)$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (re.union (str.to_re "B") (re.union (str.to_re "P") (re.union (str.to_re "X") (str.to_re "T")))) ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.union (re.range "a" "z") (re.range "A" "z")) (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.opt (re.++ (str.to_re "a") (re.++ (str.to_re "d") (str.to_re "m")))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)