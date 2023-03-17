;test regex [A-Z]{2}_[A-Z]{4}_\d{6}[A-Z]{0,2}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 0 2) (re.range "A" "Z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)