;test regex ([|]c([0-9]|[a-f]|[A-F]){8})|[|]r
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "|") (re.++ (str.to_re "c") ((_ re.loop 8 8) (re.union (re.union (re.range "0" "9") (re.range "a" "f")) (re.range "A" "F"))))) (re.++ (str.to_re "|") (str.to_re "r")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)