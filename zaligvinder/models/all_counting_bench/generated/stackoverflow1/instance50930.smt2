;test regex ([01]{3}[a-z][01]{2})(=[01])|(^t)(=[0-9]*)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ ((_ re.loop 3 3) (str.to_re "01")) (re.++ (re.range "a" "z") ((_ re.loop 2 2) (str.to_re "01")))) (re.++ (str.to_re "=") (str.to_re "01"))) (re.++ (re.++ (str.to_re "") (str.to_re "t")) (re.++ (str.to_re "=") (re.* (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)