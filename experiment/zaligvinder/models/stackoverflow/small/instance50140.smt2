;test regex (|$)?[0-9][0-9]{0,5}[0-9,k]?(-| - | to )?((|$)?[0-9][0-9]{0,5}[0,5,k]?)?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "") (re.++ (str.to_re "") (str.to_re "")))) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.++ (re.opt (re.union (re.range "0" "9") (re.union (str.to_re ",") (str.to_re "k")))) (re.++ (re.opt (re.union (re.union (str.to_re "-") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "o") (str.to_re " ")))))) (re.opt (re.++ (re.opt (re.union (str.to_re "") (re.++ (str.to_re "") (str.to_re "")))) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (re.union (str.to_re "0") (re.union (str.to_re ",") (re.union (str.to_re "5") (re.union (str.to_re ",") (str.to_re "k")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)