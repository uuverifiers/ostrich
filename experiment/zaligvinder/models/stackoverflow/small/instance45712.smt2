;test regex 95[5-9]|9[6-9]\d|[1-9]\d{3,}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "95") (re.range "5" "9")) (re.++ (str.to_re "9") (re.++ (re.range "6" "9") (re.range "0" "9")))) (re.++ (re.range "1" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)