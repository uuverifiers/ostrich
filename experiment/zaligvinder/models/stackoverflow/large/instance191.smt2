;test regex ^(?:[0-9a-fA-F]{10}|[0-9a-fA-F]{24}|[0-9a-fA-F]{26}|[0-9a-fA-F]{58})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.opt (re.union (re.union (re.union ((_ re.loop 10 10) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))) ((_ re.loop 26 26) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))) ((_ re.loop 58 58) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)