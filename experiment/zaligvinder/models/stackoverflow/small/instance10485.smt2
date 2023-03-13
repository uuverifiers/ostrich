;test regex (?:[A-Z][a-zA-Z]* ?){5}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 5 5) (re.++ (re.range "A" "Z") (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (str.to_re " ")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)