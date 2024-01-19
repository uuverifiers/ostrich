;test regex /(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i) | (^[0-9]*$)/
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "/") (re.++ (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ (re.range "1" "5") (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "89") (re.union (str.to_re "a") (str.to_re "b"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f")))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (str.to_re "i")))) (str.to_re " "))) (re.++ (str.to_re " ") (re.++ (re.++ (re.++ (str.to_re "") (re.* (re.range "0" "9"))) (str.to_re "")) (str.to_re "/"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)