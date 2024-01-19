;test regex \A(([a-zA-Z]{1,2}\d{1,2})|([a-zA-Z]{2}\d[a-zA-Z]{1}))\u{20}{0,1}\d[a-zA-Z]{2}\Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.range "0" "9") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z")))))) (re.++ ((_ re.loop 0 1) (str.to_re "\u{20}")) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "Z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)