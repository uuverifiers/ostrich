;test regex (COL03-DO178BCReqB-.{7})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "L") (re.++ (str.to_re "03") (re.++ (str.to_re "-") (re.++ (str.to_re "D") (re.++ (str.to_re "O") (re.++ (str.to_re "178") (re.++ (str.to_re "B") (re.++ (str.to_re "C") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "q") (re.++ (str.to_re "B") (re.++ (str.to_re "-") ((_ re.loop 7 7) (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)