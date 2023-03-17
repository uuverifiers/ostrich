;test regex ^[A-Za-z]+&{2}[A-Za-z]&{2}name'[ .A-Za-z]+'$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 2 2) (str.to_re "&")) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.++ ((_ re.loop 2 2) (str.to_re "&")) (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "\u{27}") (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re ".") (re.union (re.range "A" "Z") (re.range "a" "z"))))) (str.to_re "\u{27}")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)