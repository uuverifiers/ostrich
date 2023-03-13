;test regex "(MAC:[A-Z0-9]{12})+"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.++ (str.to_re "M") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re ":") ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "0" "9")))))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)