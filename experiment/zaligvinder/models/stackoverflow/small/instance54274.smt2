;test regex out\dmf\d{1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (re.range "0" "9") (re.++ (str.to_re "m") (re.++ (str.to_re "f") ((_ re.loop 1 2) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)