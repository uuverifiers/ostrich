;test regex ^(On ).{3}, (19|20)\d\d-\d\d-\d\d at \d\d:\d\d -\d\d\d\d,
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "O") (re.++ (str.to_re "n") (str.to_re " "))) ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))))))))))))))))))))))))) (str.to_re ","))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)