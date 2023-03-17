;test regex (watch\?v=[0-9a-zA-Z]){0}abc
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 0) (re.++ (str.to_re "w") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "?") (re.++ (str.to_re "v") (re.++ (str.to_re "=") (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))))))))))) (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)