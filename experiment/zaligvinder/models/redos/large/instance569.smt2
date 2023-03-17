;test regex ^[A-Z0-9]{4}SG([0-9A-F]{24})DLK([0-9A-F]{32})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "S") (re.++ (str.to_re "G") (re.++ ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.++ (str.to_re "D") (re.++ (str.to_re "L") (re.++ (str.to_re "K") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)