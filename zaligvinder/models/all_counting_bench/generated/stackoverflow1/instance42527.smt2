;test regex [VILMFWCA]{8,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "V") (re.union (str.to_re "I") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "F") (re.union (str.to_re "W") (re.union (str.to_re "C") (str.to_re "A"))))))))) ((_ re.loop 8 8) (re.union (str.to_re "V") (re.union (str.to_re "I") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "F") (re.union (str.to_re "W") (re.union (str.to_re "C") (str.to_re "A"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)