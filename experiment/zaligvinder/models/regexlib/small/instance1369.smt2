;test regex ^[AaWaKkNn][a-zA-Z]?[0-9][a-zA-Z]{1,3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "A") (re.union (str.to_re "a") (re.union (str.to_re "W") (re.union (str.to_re "a") (re.union (str.to_re "K") (re.union (str.to_re "k") (re.union (str.to_re "N") (str.to_re "n")))))))) (re.++ (re.opt (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.range "0" "9") ((_ re.loop 1 3) (re.union (re.range "a" "z") (re.range "A" "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)