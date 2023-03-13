;test regex /((http|https|ftp):\/\/(www|WWW)|(www|WWW))\.[A-Za-z]{3}/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (re.union (re.++ (re.union (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (str.to_re "p")))) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (str.to_re "s")))))) (re.++ (str.to_re "f") (re.++ (str.to_re "t") (str.to_re "p")))) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.union (re.++ (str.to_re "w") (re.++ (str.to_re "w") (str.to_re "w"))) (re.++ (str.to_re "W") (re.++ (str.to_re "W") (str.to_re "W")))))))) (re.union (re.++ (str.to_re "w") (re.++ (str.to_re "w") (str.to_re "w"))) (re.++ (str.to_re "W") (re.++ (str.to_re "W") (str.to_re "W"))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "/")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)