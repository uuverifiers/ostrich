;test regex (([a-f0-9]{2} ){27}|([a-f0-9]{2} ){13})[a-f0-9]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 27 27) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re " "))) ((_ re.loop 13 13) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re " ")))) ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)