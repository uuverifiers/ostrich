;test regex \[?\(?([0-9]{1,2}\s?marks?|[0-9]{1,2}\s?mk?s?)\)?\]?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "[")) (re.++ (re.opt (str.to_re "(")) (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "k") (re.opt (str.to_re "s")))))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "m") (re.++ (re.opt (str.to_re "k")) (re.opt (str.to_re "s"))))))) (re.++ (re.opt (str.to_re ")")) (re.opt (str.to_re "]"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)