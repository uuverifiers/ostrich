;test regex P?(([0-9]{1,}D)|([0-9]{1,}M)|([0-9]{1}Y)|(T?(([0-9]{1,}H)|([0-9]{1,}M)|([0-9]{1,}S))))
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "P")) (re.union (re.union (re.union (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "D")) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "M"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "Y"))) (re.++ (re.opt (str.to_re "T")) (re.union (re.union (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "H")) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "M"))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "S"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)