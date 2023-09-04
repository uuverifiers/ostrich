;test regex [yahoo]{5} should be yahoo
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (str.to_re "y") (re.union (str.to_re "a") (re.union (str.to_re "h") (re.union (str.to_re "o") (str.to_re "o")))))) (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "y") (re.++ (str.to_re "a") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (str.to_re "o")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)