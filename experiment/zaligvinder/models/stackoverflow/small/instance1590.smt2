;test regex \A([a-z]{3}t[1|2][a-z]{2}_([a-z][0-9]){2})\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.++ (str.to_re "t") (re.++ (re.union (str.to_re "1") (re.union (str.to_re "|") (str.to_re "2"))) (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "_") ((_ re.loop 2 2) (re.++ (re.range "a" "z") (re.range "0" "9")))))))) (str.to_re "z")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)