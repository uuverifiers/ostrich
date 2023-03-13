;test regex ([A-Z]{3})+([1-3]{1})+([A-Z]{1})+((A|B|C)|(D|E|F)|(G|H|I))
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ (re.+ ((_ re.loop 1 1) (re.range "1" "3"))) (re.++ (re.+ ((_ re.loop 1 1) (re.range "A" "Z"))) (re.union (re.union (re.union (re.union (str.to_re "A") (str.to_re "B")) (str.to_re "C")) (re.union (re.union (str.to_re "D") (str.to_re "E")) (str.to_re "F"))) (re.union (re.union (str.to_re "G") (str.to_re "H")) (str.to_re "I"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)