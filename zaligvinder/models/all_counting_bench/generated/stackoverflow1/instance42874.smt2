;test regex ^\w[GBR]{1,3}[1-9]{1,1}\d[0-9]{1,1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ ((_ re.loop 1 3) (re.union (str.to_re "G") (re.union (str.to_re "B") (str.to_re "R")))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.++ (re.range "0" "9") ((_ re.loop 1 1) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)