;test regex (^13((\ )?\d){4}$)|(^1[38]00((\ )?\d){6}$)|(^(((\(0[23478]\))|(0[23478]))(\ )?)?\d((\ )?\d){7}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "13") ((_ re.loop 4 4) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "38") (re.++ (str.to_re "00") ((_ re.loop 6 6) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9"))))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.union (re.++ (str.to_re "(") (re.++ (str.to_re "0") (re.++ (str.to_re "23478") (str.to_re ")")))) (re.++ (str.to_re "0") (str.to_re "23478"))) (re.opt (str.to_re " ")))) (re.++ (re.range "0" "9") ((_ re.loop 7 7) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)