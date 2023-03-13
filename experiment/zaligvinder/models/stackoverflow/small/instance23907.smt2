;test regex ^(?:iqn\.[0-9]{4}-[0-9]{2}(?:\.[A-Za-z](?:[A-Za-z0-9\-]*[A-Za-z0-9])?)+(?::.*)?|eui\.[0-9A-Fa-f]{16})\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "i") (re.++ (str.to_re "q") (re.++ (str.to_re "n") (re.++ (str.to_re ".") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.+ (re.++ (str.to_re ".") (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-"))))) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))))) (re.opt (re.++ (str.to_re ":") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))) (re.++ (str.to_re "e") (re.++ (str.to_re "u") (re.++ (str.to_re "i") (re.++ (str.to_re ".") ((_ re.loop 16 16) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))))))))) (str.to_re "z")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)