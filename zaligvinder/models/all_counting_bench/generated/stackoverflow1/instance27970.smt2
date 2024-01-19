;test regex \D\K(?:\d{1,4}|\d{0,4}\.\d{1,4})px
(declare-const X String)
(assert (str.in_re X (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (str.to_re "K") (re.++ (re.union ((_ re.loop 1 4) (re.range "0" "9")) (re.++ ((_ re.loop 0 4) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9"))))) (re.++ (str.to_re "p") (str.to_re "x")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)