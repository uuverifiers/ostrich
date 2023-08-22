;test regex ^(?:[5-9],?\d{3}|[1-9]\d{1,2},?\d{3}|1,000,000|1000000)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (re.range "5" "9") (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.++ (re.range "1" "9") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.++ (str.to_re "1") (re.++ (str.to_re ",") (str.to_re "000"))) (re.++ (str.to_re ",") (str.to_re "000")))) (str.to_re "1000000"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)