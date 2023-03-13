;test regex [A-Z0-9]+-(V|G)E-[0-9]{4,}-(S|A)-[0-9]{2}(\/[0-9]+)?\.pdf
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "V") (str.to_re "G")) (re.++ (str.to_re "E") (re.++ (str.to_re "-") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ (re.union (str.to_re "S") (str.to_re "A")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re "/") (re.+ (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)