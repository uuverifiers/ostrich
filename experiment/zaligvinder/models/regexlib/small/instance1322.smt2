;test regex (ES-?)?([0-9A-Z][0-9]{7}[A-Z])|([A-Z][0-9]{7}[0-9A-Z])
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.opt (str.to_re "-"))))) (re.++ (re.union (re.range "0" "9") (re.range "A" "Z")) (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.range "A" "Z")))) (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (re.range "A" "Z")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)