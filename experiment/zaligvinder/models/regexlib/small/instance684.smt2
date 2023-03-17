;test regex (0?[1-9]|[1-9][0-9])[0-9]{6}(-| )?[trwagmyfpdxbnjzsqvhlcke]
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.union (str.to_re "t") (re.union (str.to_re "r") (re.union (str.to_re "w") (re.union (str.to_re "a") (re.union (str.to_re "g") (re.union (str.to_re "m") (re.union (str.to_re "y") (re.union (str.to_re "f") (re.union (str.to_re "p") (re.union (str.to_re "d") (re.union (str.to_re "x") (re.union (str.to_re "b") (re.union (str.to_re "n") (re.union (str.to_re "j") (re.union (str.to_re "z") (re.union (str.to_re "s") (re.union (str.to_re "q") (re.union (str.to_re "v") (re.union (str.to_re "h") (re.union (str.to_re "l") (re.union (str.to_re "c") (re.union (str.to_re "k") (str.to_re "e"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)