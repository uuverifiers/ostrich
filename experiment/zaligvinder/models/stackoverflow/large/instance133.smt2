;test regex "on"[ \t\r]*(.){0,300}"."[ \t\r]*(.){0,300}"from"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{09}") (str.to_re "\u{0d}")))) (re.++ ((_ re.loop 0 300) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{22}") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{09}") (str.to_re "\u{0d}")))) (re.++ ((_ re.loop 0 300) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "f") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (str.to_re "\u{22}")))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)