;test regex [a-z0-9._%+-]{1,64}@(?:[a-z0-9-]{1,63}\.){1,125}[a-z]{2,63}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 64) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re "%") (re.union (str.to_re "+") (str.to_re "-")))))))) (re.++ (str.to_re "@") (re.++ ((_ re.loop 1 125) (re.++ ((_ re.loop 1 63) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (str.to_re "."))) ((_ re.loop 2 63) (re.range "a" "z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)