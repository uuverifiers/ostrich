;test regex =Regexextract(E2;"[A-z0-9._%+-]+@[A-z0-9.-]+\.[A-z]{2,4}")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "=") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "E") (re.++ (str.to_re "2") (re.++ (str.to_re ";") (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re "%") (re.union (str.to_re "+") (str.to_re "-")))))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-"))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 4) (re.range "A" "z")) (str.to_re "\u{22}")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)