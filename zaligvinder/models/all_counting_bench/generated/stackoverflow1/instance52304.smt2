;test regex "\\d{3}([.-])?\\d{3}\\1?\\d{4}|\\(\\d{3}\\)([.-])?\\d{3}\\2?\\d{4}"
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (re.opt (re.union (str.to_re ".") (str.to_re "-"))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "1")) (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))))))))))) (re.++ (str.to_re "\\") (re.++ (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (str.to_re "\\"))) (re.++ (re.opt (re.union (str.to_re ".") (str.to_re "-"))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "2")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (str.to_re "\u{22}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)