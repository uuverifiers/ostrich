;test regex \+?[0-9][0-9()\-\s+]{4,20}[0-9]
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 4 20) (re.union (re.range "0" "9") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "-") (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (str.to_re "+"))))))) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)