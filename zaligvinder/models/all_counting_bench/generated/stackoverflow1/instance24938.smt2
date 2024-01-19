;test regex /^(0?[1-9]|[12]\d|3[01])[\/\-](0?[1-9]|1[012])[\/\-](19\d{2}|20\d{2})$/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "12") (re.range "0" "9"))) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (re.union (str.to_re "/") (str.to_re "-")) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "20") ((_ re.loop 2 2) (re.range "0" "9")))))))))) (re.++ (str.to_re "") (str.to_re "/")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)