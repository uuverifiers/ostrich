;test regex (\"[PM]\d{3,5}Z[pm](\,)?\d{3,5}\"(\,)?)*
(declare-const X String)
(assert (str.in_re X (re.* (re.++ (str.to_re "\u{22}") (re.++ (re.union (str.to_re "P") (str.to_re "M")) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (re.++ (str.to_re "Z") (re.++ (re.union (str.to_re "p") (str.to_re "m")) (re.++ (re.opt (str.to_re ",")) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (re.++ (str.to_re "\u{22}") (re.opt (str.to_re ",")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)