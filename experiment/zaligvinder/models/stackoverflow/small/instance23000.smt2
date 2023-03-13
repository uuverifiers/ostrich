;test regex (\d{1,5}\s[^\d].{5,20}(dr|drive)(\.|\s|\,))
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ ((_ re.loop 5 20) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "d") (str.to_re "r")) (re.++ (str.to_re "d") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (str.to_re "e")))))) (re.union (re.union (str.to_re ".") (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (str.to_re ",")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)