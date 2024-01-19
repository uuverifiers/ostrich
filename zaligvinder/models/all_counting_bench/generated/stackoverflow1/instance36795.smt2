;test regex \/static\/workout\/[A-Z]{1,4}033112[A-Z]{1,5}-EQB.html
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "/") (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "k") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 4) (re.range "A" "Z")) (re.++ (str.to_re "033112") (re.++ ((_ re.loop 1 5) (re.range "A" "Z")) (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re "Q") (re.++ (str.to_re "B") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (str.to_re "l"))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)