;test regex ((?:[01]?[0-9]:)?[0-9]{1,2}(?:AM|PM)?)-((?:[01]?[0-9]:)?[0-9]{1,2}(?:AM|PM)?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.opt (re.++ (re.opt (str.to_re "01")) (re.++ (re.range "0" "9") (str.to_re ":")))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M")))))) (re.++ (str.to_re "-") (re.++ (re.opt (re.++ (re.opt (str.to_re "01")) (re.++ (re.range "0" "9") (str.to_re ":")))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)