;test regex (hello) (?:[a-zA-Z--]+ ){1,2}(beautiful) (?:[a-zA-Z--]+ ){2,4}(world)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (str.to_re "o"))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 2) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "-") (str.to_re "-"))))) (str.to_re " "))) (re.++ (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re "u") (str.to_re "l"))))))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 4) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "-") (str.to_re "-"))))) (str.to_re " "))) (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (str.to_re "d")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)