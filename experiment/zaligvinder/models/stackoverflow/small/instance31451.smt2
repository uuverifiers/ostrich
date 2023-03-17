;test regex [CURRENT]{7}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 7 7) (re.union (str.to_re "C") (re.union (str.to_re "U") (re.union (str.to_re "R") (re.union (str.to_re "R") (re.union (str.to_re "E") (re.union (str.to_re "N") (str.to_re "T"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)