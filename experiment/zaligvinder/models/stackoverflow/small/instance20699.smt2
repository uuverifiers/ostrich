;test regex RewriteRule ^[0-9]{4}/[0-9]{1,2}/[^/]+/feed/?$ /[R,L]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "R") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re " ")))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.+ (re.diff re.allchar (str.to_re "/"))) (re.++ (str.to_re "/") (re.++ (str.to_re "f") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.opt (str.to_re "/")))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.union (str.to_re "R") (re.union (str.to_re ",") (str.to_re "L")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)