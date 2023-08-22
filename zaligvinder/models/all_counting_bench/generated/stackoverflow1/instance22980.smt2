;test regex ^([0][1-9]|[1-2][0-9]|[3][0-5])([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "5"))) (re.+ (re.++ ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 1 1) (re.union (re.range "1" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "z") (str.to_re "Z"))) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)