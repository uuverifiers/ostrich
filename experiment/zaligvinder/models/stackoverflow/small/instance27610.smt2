;test regex ^(?:(IN:[AE][0-9]{7}Q)|([AE][0-9]{7}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re ":") (re.++ (re.union (str.to_re "A") (str.to_re "E")) (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "Q")))))) (re.++ (re.union (str.to_re "A") (str.to_re "E")) ((_ re.loop 7 7) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)