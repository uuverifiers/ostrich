;test regex ^[a-zA-Z]{8}[a-zA-Z]{9}[a-zA-Z]{10}.*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 10 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.diff re.allchar (str.to_re "\n")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)