;test regex m?abcwxyz<\d{2}>
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "m")) (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "w") (re.++ (str.to_re "x") (re.++ (str.to_re "y") (re.++ (str.to_re "z") (re.++ (str.to_re "<") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ">")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)