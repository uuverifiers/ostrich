;test regex [A-HJ-NPR-TV-Y]{1}[0-9]{2,3}[A-HJ-PR-Y]{3}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (str.to_re "P") (re.union (re.range "R" "T") (re.range "V" "Y")))))) (re.++ ((_ re.loop 2 3) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.union (re.range "J" "P") (re.range "R" "Y"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)