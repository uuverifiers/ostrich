;test regex '*any* constant you like!' while s/^(0*)1/${1}000/;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.* (str.to_re "\u{27}")) (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (re.* (str.to_re "y")) (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "y") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re " ") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "!") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (str.to_re "/"))))))))))))))))))))))))))))))))) (re.++ (str.to_re "") (re.++ (re.* (str.to_re "0")) (re.++ (str.to_re "1") (str.to_re "/"))))) (re.++ ((_ re.loop 1 1) (str.to_re "")) (re.++ (str.to_re "000") (re.++ (str.to_re "/") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)