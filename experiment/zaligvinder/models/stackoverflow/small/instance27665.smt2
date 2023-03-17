;test regex DeskNO[0-9]{2,3}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "k") (re.++ (str.to_re "N") (re.++ (str.to_re "O") ((_ re.loop 2 3) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)