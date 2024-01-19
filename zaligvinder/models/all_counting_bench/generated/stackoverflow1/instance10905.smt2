;test regex Price_{0}_Extract_{1}.xml
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "P") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ ((_ re.loop 0 0) (str.to_re "_")) (re.++ (str.to_re "_") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ ((_ re.loop 1 1) (str.to_re "_")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "x") (re.++ (str.to_re "m") (str.to_re "l")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)