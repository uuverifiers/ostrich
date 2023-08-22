;test regex ^ABD_DEF_GHIJ(?:_\d{8})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "D") (re.++ (str.to_re "_") (re.++ (str.to_re "D") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.++ (str.to_re "_") (re.++ (str.to_re "G") (re.++ (str.to_re "H") (re.++ (str.to_re "I") (re.++ (str.to_re "J") (re.opt (re.++ (str.to_re "_") ((_ re.loop 8 8) (re.range "0" "9"))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)