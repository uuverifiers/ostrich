;test regex \d{4,}|[3456789]\d{2}|2[56789]\d
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "3456789") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (str.to_re "56789") (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)