;test regex scan: scanning title (\d+)?.{0,500}(ignoring title)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "n") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (re.opt (re.+ (re.range "0" "9"))) (re.++ ((_ re.loop 0 500) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "n") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "l") (str.to_re "e")))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)