;test regex [a-z]{3}[cphfatblj][a-z]\d{4}[a-z]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.++ (re.union (str.to_re "c") (re.union (str.to_re "p") (re.union (str.to_re "h") (re.union (str.to_re "f") (re.union (str.to_re "a") (re.union (str.to_re "t") (re.union (str.to_re "b") (re.union (str.to_re "l") (str.to_re "j"))))))))) (re.++ (re.range "a" "z") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.range "a" "z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)