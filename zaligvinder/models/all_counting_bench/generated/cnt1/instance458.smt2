;test regex ([&?])sid=[0-9a-f]{32}&
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "&") (str.to_re "?")) (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "&")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)