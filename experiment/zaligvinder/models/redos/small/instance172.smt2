;test regex http://asa\.tv/movie/D5/gcuppapa/[a-z0-9A-Z]{32}\.flv
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "a") (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "v") (re.++ (str.to_re "/") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "v") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "/") (re.++ (str.to_re "D") (re.++ (str.to_re "5") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (re.++ (str.to_re "c") (re.++ (str.to_re "u") (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "/") (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.range "A" "Z")))) (re.++ (str.to_re ".") (re.++ (str.to_re "f") (re.++ (str.to_re "l") (str.to_re "v")))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)