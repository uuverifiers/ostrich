;test regex FM\W?(\.{0,1}\d?\.?\d?)?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "F") (re.++ (str.to_re "M") (re.++ (re.opt (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))) (re.opt (re.++ ((_ re.loop 0 1) (str.to_re ".")) (re.++ (re.opt (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)