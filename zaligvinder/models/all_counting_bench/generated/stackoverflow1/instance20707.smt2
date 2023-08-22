;test regex ^-?([0-8]?[0-9]|90)\.[0-9]{1,6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (re.++ (re.union (re.++ (re.opt (re.range "0" "8")) (re.range "0" "9")) (str.to_re "90")) (re.++ (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)