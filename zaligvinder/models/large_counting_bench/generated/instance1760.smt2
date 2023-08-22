;test regex ^([ACGTN]{1,64}\d\n){0,9999}[ACGTN]{1,64}\d$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 9999) (re.++ ((_ re.loop 1 64) (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (re.union (str.to_re "T") (str.to_re "N")))))) (re.++ (re.range "0" "9") (str.to_re "\u{0a}")))) (re.++ ((_ re.loop 1 64) (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (re.union (str.to_re "T") (str.to_re "N")))))) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)