;test regex ^([A-Z]{2}[9]{3}|[A-Z]{3}[9]{2}|[A-Z]{4}[9]{1}|[A-Z]{5})[0-9]{6}([A-Z]{1}[9]{1}|[A-Z]{2})[A-Z0-9]{3}[0-9]{2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (str.to_re "9"))) (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 2 2) (str.to_re "9")))) (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9")))) ((_ re.loop 5 5) (re.range "A" "Z"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9"))) ((_ re.loop 2 2) (re.range "A" "Z"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)