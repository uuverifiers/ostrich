;test regex ^(([a-h]|[j-n]|p|[r-z]|[A-H]|[J-N]|P|[R-Z]|[0-9]){17})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 17 17) (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.range "a" "h") (re.range "j" "n")) (str.to_re "p")) (re.range "r" "z")) (re.range "A" "H")) (re.range "J" "N")) (str.to_re "P")) (re.range "R" "Z")) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)