;test regex ^[0-9A-Z]?[0-9A-Z]{3}[A-Z]?([0-9A-Z]{6})-?([0-9])?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (re.opt (re.range "A" "Z")) (re.++ ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (re.opt (str.to_re "-")) (re.opt (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)