;test regex regcomp(&reg, "\$natureOrder\([0-9]{1,4}\)", cflags);
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (re.++ (re.++ (re.++ (str.to_re "&") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "g")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "$") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "O") (re.++ (str.to_re "r") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "(") (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (str.to_re ")") (str.to_re "\u{22}")))))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "f") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (str.to_re "s"))))))))) (str.to_re ";")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)