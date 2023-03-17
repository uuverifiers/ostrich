;test regex (([0-9]|[a-f]){32}-)*([0-9]|[a-f]){32}\.vurl\.
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "-"))) (re.++ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re ".") (re.++ (str.to_re "v") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (str.to_re "."))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)