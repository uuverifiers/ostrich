;test regex $decoded =~ s/^(.*?)((\r\n)|\n|\r){2}//m;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (str.to_re "/")))))))))))))) (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.union (re.union (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "\u{0a}")) (str.to_re "\u{0d}"))) (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "m") (str.to_re ";"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)