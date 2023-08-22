;test regex ^(?:[01]{48}0(?:001|010|011|100|101)[01]{12}10[01]{62}|0{128})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 48 48) (str.to_re "01")) (re.++ (str.to_re "0") (re.++ (re.union (re.union (re.union (re.union (str.to_re "001") (str.to_re "010")) (str.to_re "011")) (str.to_re "100")) (str.to_re "101")) (re.++ ((_ re.loop 12 12) (str.to_re "01")) (re.++ (str.to_re "10") ((_ re.loop 62 62) (str.to_re "01"))))))) ((_ re.loop 128 128) (str.to_re "0")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)