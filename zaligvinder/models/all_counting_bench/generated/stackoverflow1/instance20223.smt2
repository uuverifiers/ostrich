;test regex REP{0,1}ORTS{0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ ((_ re.loop 0 1) (str.to_re "P")) (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "T") ((_ re.loop 0 1) (str.to_re "S"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)