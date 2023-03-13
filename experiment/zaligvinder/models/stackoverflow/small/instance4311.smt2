;test regex '[ ](MA|RN|([A-Z][a-z]?[a-z]?\.){2,3})'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.++ (str.to_re "M") (str.to_re "A")) (re.++ (str.to_re "R") (str.to_re "N"))) ((_ re.loop 2 3) (re.++ (re.range "A" "Z") (re.++ (re.opt (re.range "a" "z")) (re.++ (re.opt (re.range "a" "z")) (str.to_re ".")))))) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)