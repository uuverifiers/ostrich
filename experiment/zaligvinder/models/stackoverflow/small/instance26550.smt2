;test regex [IE]{1}[NS]{1}[FT]{1}[JP]{1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "I") (str.to_re "E"))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "N") (str.to_re "S"))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "F") (str.to_re "T"))) ((_ re.loop 1 1) (re.union (str.to_re "J") (str.to_re "P"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)