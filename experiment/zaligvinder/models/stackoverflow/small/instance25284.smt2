;test regex ([A-Z]{2})|([A-Z]{3})|([A-Z]{4})|([A-Z] [A-Z])
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (re.range "A" "Z"))) ((_ re.loop 4 4) (re.range "A" "Z"))) (re.++ (re.range "A" "Z") (re.++ (str.to_re " ") (re.range "A" "Z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)