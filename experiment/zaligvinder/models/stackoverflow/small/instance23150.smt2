;test regex (facebook|twitter|flickr)\/(\d{10})\.(jpg|png|gif)_(t_w|t|s|w)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "f") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (str.to_re "k")))))))) (re.++ (str.to_re "t") (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (str.to_re "r")))))))) (re.++ (str.to_re "f") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (str.to_re "r"))))))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))) (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "_") (re.union (re.union (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "_") (str.to_re "w"))) (str.to_re "t")) (str.to_re "s")) (str.to_re "w"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)