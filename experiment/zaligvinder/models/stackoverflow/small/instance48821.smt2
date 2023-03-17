;test regex ^\/([a-zA-Z]{2})\/([a-zA-Z]{1,10})(\/[a-zA-Z1-9\+\-]+)*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "1" "9") (re.union (str.to_re "+") (str.to_re "-")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)