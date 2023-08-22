;test regex ^((00|\+)49)?(0?1[5-7][0-9]{1,})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "49"))) (re.++ (re.opt (str.to_re "0")) (re.++ (str.to_re "1") (re.++ (re.range "5" "7") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)