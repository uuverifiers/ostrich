;test regex ([A-Za-z]{5}\.[A-Za-z]{3}\.[A-Za-z]{3}\.[A-Za-z]{3}\.[0-9]{3}\.[0-9]{2})\.([0-9]{8}\-[0-9]{6})\.csv
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))))))))) (re.++ (str.to_re ".") (re.++ (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "v")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)