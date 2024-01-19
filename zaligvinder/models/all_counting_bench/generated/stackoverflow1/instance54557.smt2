;test regex ^[a-z0-9]{3,6}@fightclub\.(?:uk|lk|sa|cc|jp|se|xy|gi|rl|ss)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 6) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "@") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re ".") (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "u") (str.to_re "k")) (re.++ (str.to_re "l") (str.to_re "k"))) (re.++ (str.to_re "s") (str.to_re "a"))) (re.++ (str.to_re "c") (str.to_re "c"))) (re.++ (str.to_re "j") (str.to_re "p"))) (re.++ (str.to_re "s") (str.to_re "e"))) (re.++ (str.to_re "x") (str.to_re "y"))) (re.++ (str.to_re "g") (str.to_re "i"))) (re.++ (str.to_re "r") (str.to_re "l"))) (re.++ (str.to_re "s") (str.to_re "s")))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)