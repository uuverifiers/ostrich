;test regex r'^[A-Z]{3}[a-z]{1}[A-z]'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "r") (str.to_re "\u{27}")) (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ ((_ re.loop 1 1) (re.range "a" "z")) (re.++ (re.range "A" "z") (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)