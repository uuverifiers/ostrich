;test regex ^((([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9]))|((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3})$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (re.* (re.++ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "-"))))) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))) (str.to_re "."))) (re.union (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-"))))) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))))) (re.++ (re.++ (re.union (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (re.opt (str.to_re "01")) (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))))) ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (re.opt (str.to_re "01")) (re.++ (re.range "0" "9") (re.opt (re.range "0" "9")))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)