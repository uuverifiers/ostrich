;test regex off|(m|p)\d{3}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "o") (re.++ (str.to_re "f") (str.to_re "f"))) (re.++ (re.union (str.to_re "m") (str.to_re "p")) ((_ re.loop 3 3) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)