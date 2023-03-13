;test regex [1-9][0-9]{3}[ ]?(([a-rt-zA-RT-Z][a-zA-Z])|([sS][bce-rt-xBCE-RT-X]))
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "1" "9") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) (re.union (re.++ (re.union (re.range "a" "r") (re.union (re.range "t" "z") (re.union (re.range "A" "R") (re.range "T" "Z")))) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "b") (re.union (str.to_re "c") (re.union (re.range "e" "r") (re.union (re.range "t" "x") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (re.range "E" "R") (re.range "T" "X")))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)