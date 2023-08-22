;test regex (GB-?)?([1-9][0-9]{2}\ ?[0-9]{4}\ ?[0-9]{2})|([1-9][0-9]{2}\ ?[0-9]{4}\ ?[0-9]{2}\ ?[0-9]{3})|((GD|HA)[0-9]{3})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.opt (re.++ (str.to_re "G") (re.++ (str.to_re "B") (re.opt (str.to_re "-"))))) (re.++ (re.range "1" "9") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")))))))) (re.++ (re.range "1" "9") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")))))))))) (re.++ (re.union (re.++ (str.to_re "G") (str.to_re "D")) (re.++ (str.to_re "H") (str.to_re "A"))) ((_ re.loop 3 3) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)