;test regex /href="\/wiki\/((?:%[a-f0-9]{2})+)"/ig
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "k") (re.++ (str.to_re "i") (re.++ (str.to_re "/") (re.++ (re.+ (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (str.to_re "g"))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)