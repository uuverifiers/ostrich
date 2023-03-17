;test regex \A\$5\$rounds=1234\$salty\$[a-zA-Z0-9./]{43}\n\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "$") (re.++ (str.to_re "5") (re.++ (str.to_re "$") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "s") (re.++ (str.to_re "=") (re.++ (str.to_re "1234") (re.++ (str.to_re "$") (re.++ (str.to_re "s") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "$") (re.++ ((_ re.loop 43 43) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "/")))))) (re.++ (str.to_re "\u{0a}") (str.to_re "z"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)