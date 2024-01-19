;test regex ^-?0*(1?[0-9]{1,3}|20[0-4][0-9]|205[0-5])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (re.++ (re.* (str.to_re "0")) (re.union (re.union (re.++ (re.opt (str.to_re "1")) ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re "20") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (str.to_re "205") (re.range "0" "5")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)