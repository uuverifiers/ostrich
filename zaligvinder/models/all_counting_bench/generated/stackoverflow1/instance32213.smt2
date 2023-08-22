;test regex [0-9]{8}_(abc(_xx)?|def)\.pdf
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.opt (re.++ (str.to_re "_") (re.++ (str.to_re "x") (str.to_re "x"))))))) (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "f")))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)