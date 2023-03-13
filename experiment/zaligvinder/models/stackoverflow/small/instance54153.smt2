;test regex ^Received: .*?((?:\d{1,3}(?:\.\d{1,3}){3})|([a-z0-9]{4}(?::[a-z0-9]{4}){7}))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) ((_ re.loop 3 3) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 7 7) (re.++ (str.to_re ":") ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "0" "9")))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)