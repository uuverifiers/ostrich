;test regex ((\+|00)216)?([2579][0-9]{7}|(3[012]|4[01]|8[0128])[0-9]{6}|42[16][0-9]{5})
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) (str.to_re "216"))) (re.union (re.union (re.++ (str.to_re "2579") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (re.union (re.union (re.++ (str.to_re "3") (str.to_re "012")) (re.++ (str.to_re "4") (str.to_re "01"))) (re.++ (str.to_re "8") (str.to_re "0128"))) ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (str.to_re "42") (re.++ (str.to_re "16") ((_ re.loop 5 5) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)