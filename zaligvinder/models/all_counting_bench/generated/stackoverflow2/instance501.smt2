;test regex (?:[a-z0-9-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,})
(declare-const X String)
(assert (str.in_re X (re.union ((_ re.loop 1 61) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ ((_ re.loop 1 30) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (str.to_re ".") (re.++ (re.* (re.range "a" "z")) ((_ re.loop 2 2) (re.range "a" "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)