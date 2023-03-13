;test regex [A-Za-z]{1,2}[0-9Rr][0-9A-Za-z]? [0-9][ABD-HJLNP-UW-Zabd-hjlnp-uw-z]{2} | (jjjj)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.union (re.range "0" "9") (re.union (str.to_re "R") (str.to_re "r"))) (re.++ (re.opt (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (str.to_re " ") (re.++ (re.range "0" "9") (re.++ ((_ re.loop 2 2) (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (re.range "D" "H") (re.union (str.to_re "J") (re.union (str.to_re "L") (re.union (str.to_re "N") (re.union (re.range "P" "U") (re.union (re.range "W" "Z") (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (re.range "d" "h") (re.union (str.to_re "j") (re.union (str.to_re "l") (re.union (str.to_re "n") (re.union (re.range "p" "u") (re.range "w" "z"))))))))))))))))) (str.to_re " "))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "j") (re.++ (str.to_re "j") (re.++ (str.to_re "j") (str.to_re "j"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)