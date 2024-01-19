;test regex ^\d\d(-\d\d){3}$|^\d{8}$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") ((_ re.loop 3 3) (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.range "0" "9"))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") ((_ re.loop 8 8) (re.range "0" "9"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)