;test regex (\d{2})([NnSs])(\d{3})([EeWw])
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "N") (re.union (str.to_re "n") (re.union (str.to_re "S") (str.to_re "s")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "E") (re.union (str.to_re "e") (re.union (str.to_re "W") (str.to_re "w")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)