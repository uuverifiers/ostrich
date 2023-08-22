;test regex queryExpr: "*${0}*"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "q") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "y") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.* (str.to_re "\u{22}"))))))))))))) (re.++ (re.* ((_ re.loop 0 0) (str.to_re ""))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)