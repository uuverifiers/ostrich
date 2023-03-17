;test regex $str = $str =~ s/^(.*[a-z])\d{5}([a-z].*)$/$1XXXXX$2/i;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (str.to_re " "))))))) (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (str.to_re "/"))))))))))) (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.range "a" "z")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "a" "z") (re.* (re.diff re.allchar (str.to_re "\n")))))))) (re.++ (str.to_re "") (str.to_re "/"))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (str.to_re "X")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (str.to_re ";"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)