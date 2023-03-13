;test regex RewriteRule ^/([a-z]{2})(/.+)/?$ $2.php?lang=$1 [QSA]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "R") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re " ")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (re.++ (str.to_re "/") (re.+ (re.diff re.allchar (str.to_re "\n")))) (re.opt (str.to_re "/"))))))) (re.++ (str.to_re "") (str.to_re " "))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (re.opt (str.to_re "p")) (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (str.to_re "=")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.union (str.to_re "Q") (re.union (str.to_re "S") (str.to_re "A")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)