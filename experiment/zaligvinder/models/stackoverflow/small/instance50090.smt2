;test regex N[GC]_\d{6,9}\.\d{1,2}|(LRG|UD)_\d+
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "N") (re.++ (re.union (str.to_re "G") (str.to_re "C")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 9) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))))) (re.++ (re.union (re.++ (str.to_re "L") (re.++ (str.to_re "R") (str.to_re "G"))) (re.++ (str.to_re "U") (str.to_re "D"))) (re.++ (str.to_re "_") (re.+ (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)