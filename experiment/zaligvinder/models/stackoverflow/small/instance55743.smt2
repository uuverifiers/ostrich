;test regex egrep '(?:4[4-9][0-9]{3}|[5-9][0-9]{4}|1[0-8][0-9]{4}|19[0-5][0-9]{3}|196000) Hz'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "4") (re.++ (re.range "4" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.range "5" "9") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "1") (re.++ (re.range "0" "8") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (str.to_re "19") (re.++ (re.range "0" "5") ((_ re.loop 3 3) (re.range "0" "9"))))) (str.to_re "196000")) (re.++ (str.to_re " ") (re.++ (str.to_re "H") (re.++ (str.to_re "z") (str.to_re "\u{27}"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)