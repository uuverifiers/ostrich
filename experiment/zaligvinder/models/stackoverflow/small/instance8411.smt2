;test regex ls /dev/sd* | grep -Po '\/dev\/sd(a{2}|[b-z]+)'
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "l") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (re.* (str.to_re "d")) (str.to_re " "))))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "P") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "d") (re.++ (re.union ((_ re.loop 2 2) (str.to_re "a")) (re.+ (re.range "b" "z"))) (str.to_re "\u{27}")))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)