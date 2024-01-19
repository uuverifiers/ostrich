;test regex ^([A-Z]{1,2}|K[12]E)\d+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union ((_ re.loop 1 2) (re.range "A" "Z")) (re.++ (str.to_re "K") (re.++ (str.to_re "12") (str.to_re "E")))) (re.+ (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)