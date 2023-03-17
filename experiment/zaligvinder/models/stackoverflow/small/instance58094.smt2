;test regex (^-?[0-8][0-9]{0,1}$)|(^-?90$)|(^-?9$)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (re.++ (re.range "0" "8") ((_ re.loop 0 1) (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (str.to_re "90"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (str.to_re "9"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)