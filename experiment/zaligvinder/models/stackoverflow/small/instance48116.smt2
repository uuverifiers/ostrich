;test regex grep -Ei '[A-Z0-9.-]+@[A-Z0-9.-]+\.[A-Z]{3}' $1 | wc -l
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re "i") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-"))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-"))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "\u{27}") (str.to_re " "))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "c") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (str.to_re "l")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)