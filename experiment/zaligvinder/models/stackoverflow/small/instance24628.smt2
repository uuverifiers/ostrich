;test regex ^(((((((00|\+)49[ \-/]?)|0)[1-9][0-9]{1,4})[ \-/]?)|((((00|\+)49\()|\(0)[1-9][0-9]{1,4}\)[ \-/]?))[0-9]{1,7}([ \-/]?[0-9]{1,5})?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.++ (re.union (re.++ (re.union (str.to_re "00") (str.to_re "+")) (re.++ (str.to_re "49") (re.opt (re.union (str.to_re " ") (re.union (str.to_re "-") (str.to_re "/")))))) (str.to_re "0")) (re.++ (re.range "1" "9") ((_ re.loop 1 4) (re.range "0" "9")))) (re.opt (re.union (str.to_re " ") (re.union (str.to_re "-") (str.to_re "/"))))) (re.++ (re.union (re.++ (re.union (str.to_re "00") (str.to_re "+")) (re.++ (str.to_re "49") (str.to_re "("))) (re.++ (str.to_re "(") (str.to_re "0"))) (re.++ (re.range "1" "9") (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (str.to_re ")") (re.opt (re.union (str.to_re " ") (re.union (str.to_re "-") (str.to_re "/"))))))))) (re.++ ((_ re.loop 1 7) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "-") (str.to_re "/")))) ((_ re.loop 1 5) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)