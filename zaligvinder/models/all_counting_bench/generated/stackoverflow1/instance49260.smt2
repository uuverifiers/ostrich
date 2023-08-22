;test regex \+?(972|0)(\-)?0?(([23489]{1}\d{7})|[5]{1}\d{8})
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.++ (re.union (str.to_re "972") (str.to_re "0")) (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (str.to_re "0")) (re.union (re.++ ((_ re.loop 1 1) (str.to_re "23489")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) ((_ re.loop 8 8) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)