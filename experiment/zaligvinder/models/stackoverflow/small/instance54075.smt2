;test regex (0-9-a-zA-Z\;)*([.]){1}([0-9]){1}([;]){1}(0-9-a-zA-Z\;)*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "0") (re.++ (str.to_re "-") (re.++ (str.to_re "9") (re.++ (str.to_re "-") (re.++ (str.to_re "a") (re.++ (str.to_re "-") (re.++ (str.to_re "z") (re.++ (str.to_re "A") (re.++ (str.to_re "-") (re.++ (str.to_re "Z") (str.to_re ";")))))))))))) (re.++ ((_ re.loop 1 1) (str.to_re ".")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re ";")) (re.* (re.++ (str.to_re "0") (re.++ (str.to_re "-") (re.++ (str.to_re "9") (re.++ (str.to_re "-") (re.++ (str.to_re "a") (re.++ (str.to_re "-") (re.++ (str.to_re "z") (re.++ (str.to_re "A") (re.++ (str.to_re "-") (re.++ (str.to_re "Z") (str.to_re ";"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)