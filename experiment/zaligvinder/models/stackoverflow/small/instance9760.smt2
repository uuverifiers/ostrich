;test regex ^ \d{8} | (?: [a-zA-Z]{2} \d{6} ) $ 
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re " ")))) (re.++ (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re " "))))) (str.to_re " "))) (re.++ (str.to_re "") (str.to_re " "))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)