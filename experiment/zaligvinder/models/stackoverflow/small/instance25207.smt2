;test regex FV\/1\d{3}\/(:?(:?0[1-9])|1[0-2])\/\d{4}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "F") (re.++ (str.to_re "V") (re.++ (str.to_re "/") (re.++ (str.to_re "1") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.union (re.++ (re.opt (str.to_re ":")) (re.++ (re.opt (str.to_re ":")) (re.++ (str.to_re "0") (re.range "1" "9")))) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)