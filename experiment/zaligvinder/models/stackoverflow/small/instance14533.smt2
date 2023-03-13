;test regex "^[:digit:]{3}\\.[:digit:]{3}\\.[:digit:]{4}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.union (str.to_re ":") (re.union (str.to_re "d") (re.union (str.to_re "i") (re.union (str.to_re "g") (re.union (str.to_re "i") (re.union (str.to_re "t") (str.to_re ":")))))))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 3 3) (re.union (str.to_re ":") (re.union (str.to_re "d") (re.union (str.to_re "i") (re.union (str.to_re "g") (re.union (str.to_re "i") (re.union (str.to_re "t") (str.to_re ":")))))))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 4 4) (re.union (str.to_re ":") (re.union (str.to_re "d") (re.union (str.to_re "i") (re.union (str.to_re "g") (re.union (str.to_re "i") (re.union (str.to_re "t") (str.to_re ":")))))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)