;test regex ([\d]{1,2}:[\d]{1,2}|[\d]{1,2}:[\d]{1,2} [aApP][mM])(.*?)([\d]{1,2}:[\d]{1,2}|[\d]{1,2}:[\d]{1,2} [aApP][mM])
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 1 2) (re.range "0" "9")))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "a") (re.union (str.to_re "A") (re.union (str.to_re "p") (str.to_re "P")))) (re.union (str.to_re "m") (str.to_re "M")))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 1 2) (re.range "0" "9")))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "a") (re.union (str.to_re "A") (re.union (str.to_re "p") (str.to_re "P")))) (re.union (str.to_re "m") (str.to_re "M"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)