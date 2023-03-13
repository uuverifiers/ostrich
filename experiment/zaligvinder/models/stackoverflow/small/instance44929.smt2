;test regex echo "$num" | grep -E '^[0-5,9]*([6-8][0-5,9]*){3}$'
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (str.to_re "\u{22}")))))) (re.++ (str.to_re "") (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "\u{22}") (str.to_re " "))))))) (re.++ (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))) (re.++ (str.to_re "") (re.++ (re.* (re.union (re.range "0" "5") (re.union (str.to_re ",") (str.to_re "9")))) ((_ re.loop 3 3) (re.++ (re.range "6" "8") (re.* (re.union (re.range "0" "5") (re.union (str.to_re ",") (str.to_re "9"))))))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)