;test regex -[A-Z1-9]{2,8}(?: \(Alarm .*?\))?(?: \(Box .*\))? (.*?)\. \(
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 8) (re.union (re.range "A" "Z") (re.range "1" "9"))) (re.++ (re.opt (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (str.to_re "A") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "m") (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re ")"))))))))))) (re.++ (re.opt (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (str.to_re "B") (re.++ (str.to_re "o") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re ")"))))))))) (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re " ") (str.to_re "(")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)