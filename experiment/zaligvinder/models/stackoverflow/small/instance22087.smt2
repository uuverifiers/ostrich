;test regex echo $1 | grep -E '^[A-Z]${3}|^[0-9]${4}|^[ABCD]$'
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (str.to_re " "))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re " ")))) (re.++ (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))) (re.++ (str.to_re "") (re.range "A" "Z"))) ((_ re.loop 3 3) (str.to_re "")))) (re.++ (re.++ (str.to_re "") (re.range "0" "9")) ((_ re.loop 4 4) (str.to_re "")))) (re.++ (re.++ (str.to_re "") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (str.to_re "D"))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)