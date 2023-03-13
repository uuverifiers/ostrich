;test regex url:       /:\/{0,3}(www\.)?([0-9.\-A-Za-z]{1,253})([\u{00}-\x7F]{1,2000})$/,
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re ":") (re.++ ((_ re.loop 0 3) (str.to_re "/")) (re.++ (re.opt (re.++ (str.to_re "w") (re.++ (str.to_re "w") (re.++ (str.to_re "w") (str.to_re "."))))) (re.++ ((_ re.loop 1 253) (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "-") (re.union (re.range "A" "Z") (re.range "a" "z")))))) ((_ re.loop 1 2000) (re.range "\u{00}" "\u{7f}")))))))))))))))))) (re.++ (str.to_re "") (str.to_re "/"))) (str.to_re ","))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)