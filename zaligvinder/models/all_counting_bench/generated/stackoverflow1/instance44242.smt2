;test regex (^[a-z]([a-z_\.]*)@([a-z_\.]*)([.][a-z]{3})$)|(^[a-z]([a-z_\.]*)@([a-z_\.]*)(\.[a-z]{3})(\.[a-z]{2})*$)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.range "a" "z") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re "_") (str.to_re ".")))) (re.++ (str.to_re "@") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re "_") (str.to_re ".")))) (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "a" "z")))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.range "a" "z") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re "_") (str.to_re ".")))) (re.++ (str.to_re "@") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re "_") (str.to_re ".")))) (re.++ (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "a" "z"))) (re.* (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "a" "z")))))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)