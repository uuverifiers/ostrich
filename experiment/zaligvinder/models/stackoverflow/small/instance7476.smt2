;test regex ^(?:\d{1,5}|1[0-4]\d{4}|150000)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (str.to_re "1") (re.++ (re.range "0" "4") ((_ re.loop 4 4) (re.range "0" "9"))))) (str.to_re "150000"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)