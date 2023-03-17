;test regex (\\w+\\s){3}KEYWORD (\\w+\\s){2}\\w+
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re "\\") (str.to_re "s"))))) (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (str.to_re "Y") (re.++ (str.to_re "W") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "D") (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re "\\") (str.to_re "s"))))) (re.++ (str.to_re "\\") (re.+ (str.to_re "w")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)