;test regex categories(\/)?([a-z0-9]{0,25})?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.opt (str.to_re "/")) (re.opt ((_ re.loop 0 25) (re.union (re.range "a" "z") (re.range "0" "9")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)