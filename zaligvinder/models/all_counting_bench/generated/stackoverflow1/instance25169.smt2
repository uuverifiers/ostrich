;test regex ([\d][yY]{1})?([\d][mM]{1})?([\d][o]{0,1}(d|D){1})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.opt (re.++ (re.range "0" "9") ((_ re.loop 1 1) (re.union (str.to_re "y") (str.to_re "Y"))))) (re.++ (re.opt (re.++ (re.range "0" "9") ((_ re.loop 1 1) (re.union (str.to_re "m") (str.to_re "M"))))) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 0 1) (str.to_re "o")) ((_ re.loop 1 1) (re.union (str.to_re "d") (str.to_re "D"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)