;test regex (NA|PO|EO|PRO\s+){14}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 14 14) (re.union (re.union (re.union (re.++ (str.to_re "N") (str.to_re "A")) (re.++ (str.to_re "P") (str.to_re "O"))) (re.++ (str.to_re "E") (str.to_re "O"))) (re.++ (str.to_re "P") (re.++ (str.to_re "R") (re.++ (str.to_re "O") (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)