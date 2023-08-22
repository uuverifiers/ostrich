;test regex ^([A-Z]\d{5})|([A-Z]{3}\d{3})|([A-Z]{4}\d{2})|([A-Z]{5}\d)$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (re.range "A" "Z") ((_ re.loop 5 5) (re.range "0" "9")))) (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.++ ((_ re.loop 5 5) (re.range "A" "Z")) (re.range "0" "9")) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)