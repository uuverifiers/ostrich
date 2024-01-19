;test regex [a-f0-9]{8}[a-f0-9]{4}4[a-f0-9]{3}[89ab][a-f0-9]{3}[a-f0-9]{12}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "4") (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (re.union (str.to_re "89") (re.union (str.to_re "a") (str.to_re "b"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "0" "9"))) ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)