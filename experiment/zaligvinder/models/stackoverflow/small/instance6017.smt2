;test regex (?:[ac-hj-su-z][a-z]*|b[a-z]?|bi[a-y]|b[a-z]{3,}|i[a-z]{0,2}|inf[a-np-z]|i[a-z]{4,}|t|t[a-uw-z]|t[a-z]{2,})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (re.union (str.to_re "a") (re.union (re.range "c" "h") (re.union (re.range "j" "s") (re.range "u" "z")))) (re.* (re.range "a" "z"))) (re.++ (str.to_re "b") (re.opt (re.range "a" "z")))) (re.++ (str.to_re "b") (re.++ (str.to_re "i") (re.range "a" "y")))) (re.++ (str.to_re "b") (re.++ (re.* (re.range "a" "z")) ((_ re.loop 3 3) (re.range "a" "z"))))) (re.++ (str.to_re "i") ((_ re.loop 0 2) (re.range "a" "z")))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "f") (re.union (re.range "a" "n") (re.range "p" "z")))))) (re.++ (str.to_re "i") (re.++ (re.* (re.range "a" "z")) ((_ re.loop 4 4) (re.range "a" "z"))))) (str.to_re "t")) (re.++ (str.to_re "t") (re.union (re.range "a" "u") (re.range "w" "z")))) (re.++ (str.to_re "t") (re.++ (re.* (re.range "a" "z")) ((_ re.loop 2 2) (re.range "a" "z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)