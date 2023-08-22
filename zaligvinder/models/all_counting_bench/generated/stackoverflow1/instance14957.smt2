;test regex ^\d{18}\.(jpg|gif|ico|png|tiff)(,\d{18}\.(jpg|gif|ico|png|tiff))*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 18 18) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))) (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "i") (re.++ (str.to_re "c") (str.to_re "o")))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))) (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "f") (str.to_re "f"))))) (re.* (re.++ (str.to_re ",") (re.++ ((_ re.loop 18 18) (re.range "0" "9")) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))) (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "i") (re.++ (str.to_re "c") (str.to_re "o")))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))) (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "f") (str.to_re "f"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)