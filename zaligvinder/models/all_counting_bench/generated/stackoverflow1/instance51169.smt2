;test regex $subject =~ s/([a-z]{2})[^\da-z]+(\d{5})/$1$2/ig;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "j") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (re.range "a" "z")))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/")))))))))))))))))) (re.++ (str.to_re "") (str.to_re "1"))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (str.to_re ";")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)