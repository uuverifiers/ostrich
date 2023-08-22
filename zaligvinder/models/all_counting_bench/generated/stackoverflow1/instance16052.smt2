;test regex (\d{6})(\d{9})(\d{5})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)