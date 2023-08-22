;test regex ^(?:1(?:[0-5][0-9]{0,3}|[7-9][0-9]{0,2}|6(?:[0-2]{0,3}|[4-9][0-9]?|3(?:[0-7][0-9]?|8[0-4]?|9)?)?)?|[2-9][0-9]{0,3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "1") (re.opt (re.union (re.union (re.++ (re.range "0" "5") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (re.range "7" "9") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re "6") (re.opt (re.union (re.union ((_ re.loop 0 3) (re.range "0" "2")) (re.++ (re.range "4" "9") (re.opt (re.range "0" "9")))) (re.++ (str.to_re "3") (re.opt (re.union (re.union (re.++ (re.range "0" "7") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "8") (re.opt (re.range "0" "4")))) (str.to_re "9")))))))))) (re.++ (re.range "2" "9") ((_ re.loop 0 3) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)