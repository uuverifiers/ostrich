;test regex GCAT{8,5}[ACGT]{01,7}[CT]G
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "G") (re.++ (str.to_re "C") (re.++ (str.to_re "A") (re.++ ((_ re.loop 8 5) (str.to_re "T")) (re.++ ((_ re.loop 1 7) (re.union (str.to_re "A") (re.union (str.to_re "C") (re.union (str.to_re "G") (str.to_re "T"))))) (re.++ (re.union (str.to_re "C") (str.to_re "T")) (str.to_re "G")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)