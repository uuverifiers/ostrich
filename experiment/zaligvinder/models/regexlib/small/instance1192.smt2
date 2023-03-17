;test regex ^((01[0-9])\d{9}$|(1[0-9])\d{9}$|((00\d{5,6}|\+\d{4,6}|\+[(]\d{1,3}[)]\d{3}))(|[-\/])\d{8}$)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.union (re.union (re.++ (re.++ (re.++ (str.to_re "01") (re.range "0" "9")) ((_ re.loop 9 9) (re.range "0" "9"))) (str.to_re "")) (re.++ (re.++ (re.++ (str.to_re "1") (re.range "0" "9")) ((_ re.loop 9 9) (re.range "0" "9"))) (str.to_re ""))) (re.++ (re.++ (re.union (re.union (re.++ (str.to_re "00") ((_ re.loop 5 6) (re.range "0" "9"))) (re.++ (str.to_re "+") ((_ re.loop 4 6) (re.range "0" "9")))) (re.++ (str.to_re "+") (re.++ (str.to_re "(") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ")") ((_ re.loop 3 3) (re.range "0" "9"))))))) (re.++ (re.union (str.to_re "") (re.++ (str.to_re "") (re.union (str.to_re "-") (str.to_re "/")))) ((_ re.loop 8 8) (re.range "0" "9")))) (str.to_re ""))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)