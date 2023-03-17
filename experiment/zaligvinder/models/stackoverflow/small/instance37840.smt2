;test regex ^\d{4}a(bc|gh)+d*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "a") (re.++ (re.+ (re.union (re.++ (str.to_re "b") (str.to_re "c")) (re.++ (str.to_re "g") (str.to_re "h")))) (re.* (str.to_re "d")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)