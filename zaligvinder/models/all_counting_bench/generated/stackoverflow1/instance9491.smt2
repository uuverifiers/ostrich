;test regex http://[a-z]{1,20}.blogspot.com/\d{4}/\d{2}/([^\/]+)\.(.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 20) (re.range "a" "z")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "/") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.+ (re.diff re.allchar (str.to_re "/"))) (re.++ (str.to_re ".") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)