;test regex ^((BITCOINCASH:)?(Q|P)[A-Z0-9]{41})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (str.to_re "B") (re.++ (str.to_re "I") (re.++ (str.to_re "T") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "C") (re.++ (str.to_re "A") (re.++ (str.to_re "S") (re.++ (str.to_re "H") (str.to_re ":"))))))))))))) (re.++ (re.union (str.to_re "Q") (str.to_re "P")) ((_ re.loop 41 41) (re.union (re.range "A" "Z") (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)