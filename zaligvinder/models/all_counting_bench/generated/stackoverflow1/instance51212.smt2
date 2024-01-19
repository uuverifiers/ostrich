;test regex [VLIM]{3}D{3}[AG]{2}E{2}[A-IK-NP-TV-Z]D
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (str.to_re "V") (re.union (str.to_re "L") (re.union (str.to_re "I") (str.to_re "M"))))) (re.++ ((_ re.loop 3 3) (str.to_re "D")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "G"))) (re.++ ((_ re.loop 2 2) (str.to_re "E")) (re.++ (re.union (re.range "A" "I") (re.union (re.range "K" "N") (re.union (re.range "P" "T") (re.range "V" "Z")))) (str.to_re "D"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)