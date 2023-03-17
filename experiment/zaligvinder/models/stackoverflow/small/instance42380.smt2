;test regex (([0-9]{1,2}|[a-z]{1,3})-([0-9]{2,3}|[a-z]{2,3})-([0-9]{1,2}|[a-z]{1,2})){8}/gi
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.++ (re.union ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 1 3) (re.range "a" "z"))) (re.++ (str.to_re "-") (re.++ (re.union ((_ re.loop 2 3) (re.range "0" "9")) ((_ re.loop 2 3) (re.range "a" "z"))) (re.++ (str.to_re "-") (re.union ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 1 2) (re.range "a" "z")))))))) (re.++ (str.to_re "/") (re.++ (str.to_re "g") (str.to_re "i"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)