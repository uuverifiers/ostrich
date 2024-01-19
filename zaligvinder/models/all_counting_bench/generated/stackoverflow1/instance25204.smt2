;test regex ^[a-z0-9](\.?[a-z0-9]){5,}@gmail\.com$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.++ (re.* (re.++ (re.opt (str.to_re ".")) (re.union (re.range "a" "z") (re.range "0" "9")))) ((_ re.loop 5 5) (re.++ (re.opt (str.to_re ".")) (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.++ (str.to_re "@") (re.++ (str.to_re "g") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)