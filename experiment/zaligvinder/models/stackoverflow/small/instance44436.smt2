;test regex $ts =~ s|^(\d{4})/(\d{2})/(\d{2})(.+)$|$2/$3/$1$4|;
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (str.to_re "t") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (str.to_re "s")))))))) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.+ (re.diff re.allchar (str.to_re "\n"))))))))) (str.to_re ""))) (re.++ (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "2") (str.to_re "/"))) (re.++ (str.to_re "") (re.++ (str.to_re "3") (str.to_re "/")))) (re.++ (str.to_re "") (str.to_re "1"))) (re.++ (str.to_re "") (str.to_re "4")))) (str.to_re ";"))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)