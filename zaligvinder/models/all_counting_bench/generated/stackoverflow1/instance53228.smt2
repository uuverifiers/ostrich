;test regex pattern="0?[0-9]|1[0-2]|[A-Za-z]{1,2}"
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.opt (str.to_re "0")) (re.range "0" "9"))))))))))) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)