;test regex ^\n*MKCOL[^s]{432}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (str.to_re "\u{0a}")) (re.++ (str.to_re "M") (re.++ (str.to_re "K") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "L") ((_ re.loop 432 432) (re.diff re.allchar (str.to_re "s"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)