;test regex .*[pP][aA4][sS$]{2}[wW][oO0][rR][dD].*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (re.union (str.to_re "a") (re.union (str.to_re "A") (str.to_re "4"))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "s") (re.union (str.to_re "S") (str.to_re "$")))) (re.++ (re.union (str.to_re "w") (str.to_re "W")) (re.++ (re.union (str.to_re "o") (re.union (str.to_re "O") (str.to_re "0"))) (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.++ (re.union (str.to_re "d") (str.to_re "D")) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)