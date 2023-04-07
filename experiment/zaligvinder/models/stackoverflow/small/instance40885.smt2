;test regex "^(?:0?|\\d*)(\\d{10})\\d?$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.union (re.opt (str.to_re "0")) (re.++ (str.to_re "\\") (re.* (str.to_re "d")))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 10 10) (str.to_re "d"))) (re.++ (str.to_re "\\") (re.opt (str.to_re "d"))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)