;test regex "(\\d|A):(\\d|A)(:(\\d|A)\|(\\d|A):(\\d|A)){2}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.++ (str.to_re "\\") (str.to_re "d")) (str.to_re "A")) (re.++ (str.to_re ":") (re.++ (re.union (re.++ (str.to_re "\\") (str.to_re "d")) (str.to_re "A")) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re ":") (re.++ (re.union (re.++ (str.to_re "\\") (str.to_re "d")) (str.to_re "A")) (re.++ (str.to_re "|") (re.++ (re.union (re.++ (str.to_re "\\") (str.to_re "d")) (str.to_re "A")) (re.++ (str.to_re ":") (re.union (re.++ (str.to_re "\\") (str.to_re "d")) (str.to_re "A")))))))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)