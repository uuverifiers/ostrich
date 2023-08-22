;test regex (\w+)[-_](\d{4}[-_]\d{2}[-_]\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.union (str.to_re "-") (str.to_re "_")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.union (str.to_re "-") (str.to_re "_")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "-") (str.to_re "_")) ((_ re.loop 2 2) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)