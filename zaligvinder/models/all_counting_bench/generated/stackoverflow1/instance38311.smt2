;test regex (<a href="#)([^"]+)("{1})>
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "<") (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (str.to_re "#")))))))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ ((_ re.loop 1 1) (str.to_re "\u{22}")) (str.to_re ">"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)