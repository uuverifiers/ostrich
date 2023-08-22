;test regex (\d*\.?(?:\d{0,3}_?)*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) (re.* (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.opt (str.to_re "_"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)