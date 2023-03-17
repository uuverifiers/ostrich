;test regex ^(4915[0-1]|491[0-4]\d|490\d\d|4[0-8]\d{3}|[1-3]\d{4}|[1-9]\d{0,3}|0)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "4915") (re.range "0" "1")) (re.++ (str.to_re "491") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (str.to_re "490") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "4") (re.++ (re.range "0" "8") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "3") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "0"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)