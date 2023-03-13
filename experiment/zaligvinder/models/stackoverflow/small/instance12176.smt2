;test regex CHECK(mac RLIKE '^([0-9A-F]{2}:){6}$')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "K") (re.++ (re.++ (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))))))) (re.++ (str.to_re "") ((_ re.loop 6 6) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re ":"))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)