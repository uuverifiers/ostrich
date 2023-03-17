;test regex ((\+|00)216)?(74|71|78|70|72|9|4|2|5|73|75|76|77|79)[0-9]{6}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) (str.to_re "216"))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "74") (str.to_re "71")) (str.to_re "78")) (str.to_re "70")) (str.to_re "72")) (str.to_re "9")) (str.to_re "4")) (str.to_re "2")) (str.to_re "5")) (str.to_re "73")) (str.to_re "75")) (str.to_re "76")) (str.to_re "77")) (str.to_re "79")) ((_ re.loop 6 6) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)