;test regex [-_A-Za-z0-9]{10}[AEIMQUYcgkosw048]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 10 10) (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.union (str.to_re "A") (re.union (str.to_re "E") (re.union (str.to_re "I") (re.union (str.to_re "M") (re.union (str.to_re "Q") (re.union (str.to_re "U") (re.union (str.to_re "Y") (re.union (str.to_re "c") (re.union (str.to_re "g") (re.union (str.to_re "k") (re.union (str.to_re "o") (re.union (str.to_re "s") (re.union (str.to_re "w") (str.to_re "048")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)