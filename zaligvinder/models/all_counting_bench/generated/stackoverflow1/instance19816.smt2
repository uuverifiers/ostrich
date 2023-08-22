;test regex ^([01]?[0-9]|2[0-3]):[0-5][0-9]{2}(AM|PM)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.opt (str.to_re "01")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)