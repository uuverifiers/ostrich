;test regex ^[pP]?[tT]?[nN]?[oO]?[0-9]{7,11}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.union (str.to_re "p") (str.to_re "P"))) (re.++ (re.opt (re.union (str.to_re "t") (str.to_re "T"))) (re.++ (re.opt (re.union (str.to_re "n") (str.to_re "N"))) (re.++ (re.opt (re.union (str.to_re "o") (str.to_re "O"))) ((_ re.loop 7 11) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)