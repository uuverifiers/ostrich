;test regex (.*\n){0,5}We want the available.*(\n.*){0,5}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}"))) (re.++ (str.to_re "W") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 0 5) (re.++ (str.to_re "\u{0a}") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)