;test regex ^0?[0-9]|1[0-2]|[PK]{2}|null|$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "0")) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) ((_ re.loop 2 2) (re.union (str.to_re "P") (str.to_re "K")))) (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (str.to_re "l"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)