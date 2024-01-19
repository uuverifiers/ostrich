;test regex [AGCT]{1,12000}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 1 12000) (re.union (str.to_re "A") (re.union (str.to_re "G") (re.union (str.to_re "C") (str.to_re "T")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)