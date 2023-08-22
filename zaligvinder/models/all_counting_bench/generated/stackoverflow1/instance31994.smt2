;test regex ^(4[0-9]{12}(?:[0-9]{3})?|([51|52|53|54|55]{2})([0-9]{14})|3[47][0-9]{13})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "4") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.opt ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "51") (re.union (str.to_re "|") (re.union (str.to_re "52") (re.union (str.to_re "|") (re.union (str.to_re "53") (re.union (str.to_re "|") (re.union (str.to_re "54") (re.union (str.to_re "|") (str.to_re "55")))))))))) ((_ re.loop 14 14) (re.range "0" "9")))) (re.++ (str.to_re "3") (re.++ (str.to_re "47") ((_ re.loop 13 13) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)