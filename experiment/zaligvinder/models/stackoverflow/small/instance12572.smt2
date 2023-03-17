;test regex ([A-Za-z0-9]{1,})\.([A-Za-z0-9]{1,10})\.?([A-Za-z]{1,})\.?([A-Za-z]{1,})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 10) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.opt (str.to_re ".")) (re.++ (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (re.opt (str.to_re ".")) (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)