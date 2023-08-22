;test regex ^1(?:[06]\d{2}|116|4[369]\d|59\d)\d{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "06") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "116")) (re.++ (str.to_re "4") (re.++ (str.to_re "369") (re.range "0" "9")))) (re.++ (str.to_re "59") (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)