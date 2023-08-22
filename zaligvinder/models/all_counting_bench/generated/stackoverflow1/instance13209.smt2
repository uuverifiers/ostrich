;test regex ^[A-Z]{2}(-[0-2](-[A-Z0-9]{2}(-[A-Z0-9](-[A-Z0-9]{3}(-[A-Z0-9]{7}(-[A-Z0-9]{8})?)?)?)?)?)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.opt (re.++ (str.to_re "-") (re.++ (re.range "0" "2") (re.opt (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "-") (re.++ (re.union (re.range "A" "Z") (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "-") (re.++ ((_ re.loop 7 7) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "-") ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "0" "9")))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)