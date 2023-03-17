;test regex Value="((A-Z{1,3})?|(\-)?)(\d*\.\d*)(\D{1,3})?"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "V") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.opt (re.++ (str.to_re "A") (re.++ (str.to_re "-") ((_ re.loop 1 3) (str.to_re "Z"))))) (re.opt (str.to_re "-"))) (re.++ (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re ".") (re.* (re.range "0" "9")))) (re.++ (re.opt ((_ re.loop 1 3) (re.diff re.allchar (re.range "0" "9")))) (str.to_re "\u{22}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)