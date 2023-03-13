;test regex ("^[A-Za-z]{1}\d{3}[- /]\d{3}[- /]\d{2}[- /]\d{3}[- /]\d{1}$")
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re "/"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re "/"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re "/"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re "/"))) ((_ re.loop 1 1) (re.range "0" "9"))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)