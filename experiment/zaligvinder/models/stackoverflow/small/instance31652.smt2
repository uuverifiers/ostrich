;test regex ba{2,4} will match baa, baaa and baaaa.
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "b") (re.++ ((_ re.loop 2 4) (str.to_re "a")) (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (str.to_re "a"))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.diff re.allchar (str.to_re "\n")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)