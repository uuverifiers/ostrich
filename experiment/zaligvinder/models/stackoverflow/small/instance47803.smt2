;test regex (?:<img.*){1}((width|height)=['"]\d*['"]) (?:.*\/>|>){1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "<") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "g") (re.* (re.diff re.allchar (str.to_re "\n")))))))) (re.++ (re.++ (re.union (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "t") (str.to_re "h"))))) (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "h") (str.to_re "t"))))))) (re.++ (str.to_re "=") (re.++ (re.union (str.to_re "\u{27}") (str.to_re "\u{22}")) (re.++ (re.* (re.range "0" "9")) (re.union (str.to_re "\u{27}") (str.to_re "\u{22}")))))) (re.++ (str.to_re " ") ((_ re.loop 1 1) (re.union (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "/") (str.to_re ">"))) (str.to_re ">"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)