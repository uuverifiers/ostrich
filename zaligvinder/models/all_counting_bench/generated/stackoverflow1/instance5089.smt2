;test regex ([\\d]{2}[\\s][\\d]{3}[\\s][\\d]{3})|([\\d]{3}[\\s][\\d]{3}[\\s][\\d]{3})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.union (str.to_re "\\") (str.to_re "d"))) (re.++ (re.union (str.to_re "\\") (str.to_re "s")) (re.++ ((_ re.loop 3 3) (re.union (str.to_re "\\") (str.to_re "d"))) (re.++ (re.union (str.to_re "\\") (str.to_re "s")) ((_ re.loop 3 3) (re.union (str.to_re "\\") (str.to_re "d"))))))) (re.++ ((_ re.loop 3 3) (re.union (str.to_re "\\") (str.to_re "d"))) (re.++ (re.union (str.to_re "\\") (str.to_re "s")) (re.++ ((_ re.loop 3 3) (re.union (str.to_re "\\") (str.to_re "d"))) (re.++ (re.union (str.to_re "\\") (str.to_re "s")) ((_ re.loop 3 3) (re.union (str.to_re "\\") (str.to_re "d"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)