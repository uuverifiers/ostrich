;test regex ^(?:[0-9A-F]{8}|[0-9A-F]{12}|[0-9A-F]{32})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "A" "F")))) ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)