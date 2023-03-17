;test regex ^([51|52|53|54|55]{2})([0-9]{14})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.union (str.to_re "51") (re.union (str.to_re "|") (re.union (str.to_re "52") (re.union (str.to_re "|") (re.union (str.to_re "53") (re.union (str.to_re "|") (re.union (str.to_re "54") (re.union (str.to_re "|") (str.to_re "55")))))))))) ((_ re.loop 14 14) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)