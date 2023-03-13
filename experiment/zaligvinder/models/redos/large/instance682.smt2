;test regex href=(.{1,125})>.{1,90}(Staffel|Season).*(\d{1,2}-?\d{1,2}|\d{1,2})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ ((_ re.loop 1 125) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ">") (re.++ ((_ re.loop 1 90) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "e") (str.to_re "l"))))))) (re.++ (str.to_re "S") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "o") (str.to_re "n"))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 2) (re.range "0" "9")))) ((_ re.loop 1 2) (re.range "0" "9")))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)