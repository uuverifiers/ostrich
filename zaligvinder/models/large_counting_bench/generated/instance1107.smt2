;test regex ^(?:(?:xn--)?[a-z0-9][a-z0-9-_]{0,61}[a-z0-9]?\.)+(?:xn--)?(?:[a-z0-9-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.++ (re.opt (re.++ (str.to_re "x") (re.++ (str.to_re "n") (re.++ (str.to_re "-") (str.to_re "-"))))) (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "_"))))) (re.++ (re.opt (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".")))))) (re.++ (re.opt (re.++ (str.to_re "x") (re.++ (str.to_re "n") (re.++ (str.to_re "-") (str.to_re "-"))))) (re.union ((_ re.loop 1 61) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ ((_ re.loop 1 30) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (str.to_re ".") (re.++ (re.* (re.range "a" "z")) ((_ re.loop 2 2) (re.range "a" "z"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)