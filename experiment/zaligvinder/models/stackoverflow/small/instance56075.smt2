;test regex (^rotate|rotate$|\ {1}rotate\ {1})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "e"))))))) (re.++ (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "e")))))) (str.to_re ""))) (re.++ ((_ re.loop 1 1) (str.to_re " ")) (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") ((_ re.loop 1 1) (str.to_re " "))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)