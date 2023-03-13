;test regex r"^(BOA_[0-9]{4}-[0-9]{1,3})(?:CO)?\.[Pp][Dd][Ff]\Z"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "r") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "B") (re.++ (str.to_re "O") (re.++ (str.to_re "A") (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 1 3) (re.range "0" "9")))))))) (re.++ (re.opt (re.++ (str.to_re "C") (str.to_re "O"))) (re.++ (str.to_re ".") (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.++ (re.union (str.to_re "D") (str.to_re "d")) (re.++ (re.union (str.to_re "F") (str.to_re "f")) (re.++ (str.to_re "Z") (str.to_re "\u{22}"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)