;test regex ^3(?:0[0-5]|[68][0-9])[0-9]{11}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "3") (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "5")) (re.++ (str.to_re "68") (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)