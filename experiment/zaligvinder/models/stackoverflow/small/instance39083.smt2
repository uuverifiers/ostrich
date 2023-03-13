;test regex /[A-Za-z0-9-_.]{2,16}/all|[0-9]{4}/
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 16) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (re.union (str.to_re "_") (str.to_re "."))))))) (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (str.to_re "l")))))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)