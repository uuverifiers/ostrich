;test regex ; ([A-Z][a-z]{1,3} \d[\d.]*[a-z]?-\d[\d.]*[a-z])
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re ";") (re.++ (str.to_re " ") (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 1 3) (re.range "a" "z")) (re.++ (str.to_re " ") (re.++ (re.range "0" "9") (re.++ (re.* (re.union (re.range "0" "9") (str.to_re "."))) (re.++ (re.opt (re.range "a" "z")) (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (re.* (re.union (re.range "0" "9") (str.to_re "."))) (re.range "a" "z"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)