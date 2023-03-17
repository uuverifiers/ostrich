;test regex ([0-9]{1}[A-Z0-9]{5}|[A-Z0-9]{5}[0-9]{1}|[A-Z]{1}(?:[0-9]{1}[A-Z0-9]{3}|[A-Z0-9]{3}[0-9]{1}|[A-Z]{1}(?:[0-9]{1}[A-Z]{1}[A-Z]{1}|[0-9]{1})[A-Z]{1})[A-Z]{1})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.++ (re.union (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "A" "Z")))) ((_ re.loop 1 1) (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "A" "Z"))))) ((_ re.loop 1 1) (re.range "A" "Z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)