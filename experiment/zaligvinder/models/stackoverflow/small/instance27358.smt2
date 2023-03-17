;test regex RewriteRule ^(.*)-[0-9]{10}/$ /$1/ [L,QSA]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "R") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re " ")))))))))))) (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "/")))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (str.to_re "/")))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.union (str.to_re "L") (re.union (str.to_re ",") (re.union (str.to_re "Q") (re.union (str.to_re "S") (str.to_re "A"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)