;test regex /\/hellos{0,1}[-_.]{0,1}world|ls\/gim/
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ ((_ re.loop 0 1) (str.to_re "s")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re "-") (re.union (str.to_re "_") (str.to_re ".")))) (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (str.to_re "d")))))))))))))) (re.++ (str.to_re "l") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (str.to_re "/"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)