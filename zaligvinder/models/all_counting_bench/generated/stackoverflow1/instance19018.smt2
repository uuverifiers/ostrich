;test regex ^(\\D*|\\d{1,8}(\\D|$)|\\d{10,})*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.* (re.union (re.union (re.++ (str.to_re "\\") (re.* (str.to_re "D"))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 8) (str.to_re "d")) (re.union (re.++ (str.to_re "\\") (str.to_re "D")) (str.to_re ""))))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "d")) ((_ re.loop 10 10) (str.to_re "d"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)