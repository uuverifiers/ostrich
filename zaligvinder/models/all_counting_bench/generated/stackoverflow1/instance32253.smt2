;test regex ([A-Z]{2,4})|([A-Z] [A-Z])
(declare-const X String)
(assert (str.in_re X (re.union ((_ re.loop 2 4) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.++ (str.to_re " ") (re.range "A" "Z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)