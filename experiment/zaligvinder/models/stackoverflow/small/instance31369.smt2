;test regex (([\d\*]{2,3}|\d)[A-Z\*]{0,3})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 3) (re.union (re.range "0" "9") (str.to_re "*"))) (re.range "0" "9")) ((_ re.loop 0 3) (re.union (re.range "A" "Z") (str.to_re "*"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)