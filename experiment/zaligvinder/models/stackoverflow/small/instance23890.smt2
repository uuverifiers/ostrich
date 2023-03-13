;test regex ^[EPTVeptv](-(\d{4,12})?)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "E") (re.union (str.to_re "P") (re.union (str.to_re "T") (re.union (str.to_re "V") (re.union (str.to_re "e") (re.union (str.to_re "p") (re.union (str.to_re "t") (str.to_re "v")))))))) (re.opt (re.++ (str.to_re "-") (re.opt ((_ re.loop 4 12) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)