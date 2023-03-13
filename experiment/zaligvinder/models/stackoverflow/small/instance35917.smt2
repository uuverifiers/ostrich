;test regex "[A-Z](?:\\D\\d\\D|\\d\\D|\\d|\\d{2}|\\D\\d|\\D\\d\\d|EI)\\s??\\d{1}\\D{2}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.range "A" "Z") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "\\") (re.++ (str.to_re "D") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re "\\") (str.to_re "D")))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re "\\") (str.to_re "D"))))) (re.++ (str.to_re "\\") (str.to_re "d"))) (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d")))) (re.++ (str.to_re "\\") (re.++ (str.to_re "D") (re.++ (str.to_re "\\") (str.to_re "d"))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "D") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re "\\") (str.to_re "d"))))))) (re.++ (str.to_re "E") (str.to_re "I"))) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "D")) (str.to_re "\u{22}"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)