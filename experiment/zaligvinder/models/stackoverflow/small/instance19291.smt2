;test regex (?:[ATGC]{3}){8,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* ((_ re.loop 3 3) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (str.to_re "C")))))) ((_ re.loop 8 8) ((_ re.loop 3 3) (re.union (str.to_re "A") (re.union (str.to_re "T") (re.union (str.to_re "G") (str.to_re "C")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)