;test regex "[a-zA-Z]{3}(\\d[\\W_]*){11}\\d"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 11 11) (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.* (re.union (str.to_re "\\") (re.union (str.to_re "W") (str.to_re "_"))))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)