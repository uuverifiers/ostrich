;test regex (F[0-9]{1,4})(\([^_\]]+\))(?:_(OR|NOT|AND)_)?
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "F") ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ (re.++ (str.to_re "(") (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "_")) (re.diff re.allchar (str.to_re "]")))) (str.to_re ")"))) (re.opt (re.++ (str.to_re "_") (re.++ (re.union (re.union (re.++ (str.to_re "O") (str.to_re "R")) (re.++ (str.to_re "N") (re.++ (str.to_re "O") (str.to_re "T")))) (re.++ (str.to_re "A") (re.++ (str.to_re "N") (str.to_re "D")))) (str.to_re "_"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)