;test regex ^\/.*?(\.(jpeg|jpg|gif|png|htm|html)|([^\.])[\w-]{1})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ (str.to_re ".") (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (str.to_re "g")))) (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g")))) (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (str.to_re "m")))) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (str.to_re "l")))))) (re.++ (re.diff re.allchar (str.to_re ".")) ((_ re.loop 1 1) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "-")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)