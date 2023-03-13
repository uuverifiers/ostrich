;test regex ^#q=(.){1,50}&type=([a-zA-Z]{5})&offset=([0-9]{1,8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "#") (re.++ (str.to_re "q") (re.++ (str.to_re "=") (re.++ ((_ re.loop 1 50) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "&") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "&") (re.++ (str.to_re "o") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "=") ((_ re.loop 1 8) (re.range "0" "9")))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)