;test regex ([a-zA-Z]{1,8}-)?(19|20)\d{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 1 8) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-"))) (re.++ (re.union (str.to_re "19") (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)