;test regex ^-?([1]?[1-7][1-9]|[1]?[1-8][0]|[1-9]?[0-9])\.{1}\d{1,6}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (re.++ (re.union (re.union (re.++ (re.opt (str.to_re "1")) (re.++ (re.range "1" "7") (re.range "1" "9"))) (re.++ (re.opt (str.to_re "1")) (re.++ (re.range "1" "8") (str.to_re "0")))) (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)