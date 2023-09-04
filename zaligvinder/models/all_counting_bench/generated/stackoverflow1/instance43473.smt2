;test regex ^\d{1,12}(?:\d{0,3}|\d{0,2},\d|\d{0,1},\d\d|,\d\d\d)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 12) (re.range "0" "9")) (re.union (re.union (re.union ((_ re.loop 0 3) (re.range "0" "9")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (str.to_re ",") (re.range "0" "9")))) (re.++ ((_ re.loop 0 1) (re.range "0" "9")) (re.++ (str.to_re ",") (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (str.to_re ",") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)