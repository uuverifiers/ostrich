;test regex [0-9]{6,7}|[a-zA-Z]{1,3}-[0-9]{1,6}
(declare-const X String)
(assert (str.in_re X (re.union ((_ re.loop 6 7) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "-") ((_ re.loop 1 6) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)