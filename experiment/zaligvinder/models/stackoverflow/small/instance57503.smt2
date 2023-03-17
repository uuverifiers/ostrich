;test regex ^(?:[1-8][0-9]{3,}|9(?:[0-4][0-9]{2,}|[6-9][0-9]+|5(?:[5-9][0-9]*|[0-4][0-9]+)))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.range "1" "8") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "9") (re.union (re.union (re.++ (re.range "0" "4") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.range "6" "9") (re.+ (re.range "0" "9")))) (re.++ (str.to_re "5") (re.union (re.++ (re.range "5" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "0" "4") (re.+ (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)