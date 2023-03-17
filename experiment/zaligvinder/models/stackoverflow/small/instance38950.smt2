;test regex ^(2[5-9]\d*|[3-9]\d+|[12]\d{2,})000$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (str.to_re "2") (re.++ (re.range "5" "9") (re.* (re.range "0" "9")))) (re.++ (re.range "3" "9") (re.+ (re.range "0" "9")))) (re.++ (str.to_re "12") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))) (str.to_re "000"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)