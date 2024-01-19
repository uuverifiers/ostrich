;test regex ^([www.]{0,4})([A-Za-z0-9]*)(.com)([.ar]{0,3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 4) (re.union (str.to_re "w") (re.union (str.to_re "w") (re.union (str.to_re "w") (str.to_re "."))))) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))) ((_ re.loop 0 3) (re.union (str.to_re ".") (re.union (str.to_re "a") (str.to_re "r")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)