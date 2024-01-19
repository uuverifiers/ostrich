;test regex (fax=)?1?\d{9}@domain.com
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "f") (re.++ (str.to_re "a") (re.++ (str.to_re "x") (str.to_re "="))))) (re.++ (re.opt (str.to_re "1")) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "@") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)