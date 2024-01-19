;test regex (OS)\\s(((\\w{3})(([A-Za-z0-9]{2})|(\\w{3})(\\w{3}))\\/?){1,5})\\r
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "O") (str.to_re "S")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ ((_ re.loop 1 5) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "w"))) (re.++ (re.union ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "w"))) (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "w"))))) (re.++ (str.to_re "\\") (re.opt (str.to_re "/")))))) (re.++ (str.to_re "\\") (str.to_re "r"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)