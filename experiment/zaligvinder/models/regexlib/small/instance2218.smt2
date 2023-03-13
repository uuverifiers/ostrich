;test regex ^[A-Z]{3}[G|A|F|C|T|H|P]{1}[A-Z]{1}\d{4}[A-Z]{1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "G") (re.union (str.to_re "|") (re.union (str.to_re "A") (re.union (str.to_re "|") (re.union (str.to_re "F") (re.union (str.to_re "|") (re.union (str.to_re "C") (re.union (str.to_re "|") (re.union (str.to_re "T") (re.union (str.to_re "|") (re.union (str.to_re "H") (re.union (str.to_re "|") (str.to_re "P")))))))))))))) (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)