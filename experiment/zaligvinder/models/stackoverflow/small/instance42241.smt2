;test regex RewriteRule ^[^/]+/([0-9]{3}+)/?$ album.php?ref=$1 [L]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "R") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re " ")))))))))))) (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (str.to_re "/"))) (re.++ (str.to_re "/") (re.++ (re.+ ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (str.to_re "/"))))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "b") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "h") (re.++ (re.opt (str.to_re "p")) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (str.to_re "=")))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (str.to_re "L")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)