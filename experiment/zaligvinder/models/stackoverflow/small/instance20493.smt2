;test regex ([1-9]{0,9}(?:\.\d+)?m\h*-\h*\d{0,9}(?:\.\d+)?m)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 9) (re.range "1" "9")) (re.++ (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.++ (str.to_re "m") (re.++ (re.* (str.to_re "h")) (re.++ (str.to_re "-") (re.++ (re.* (str.to_re "h")) (re.++ ((_ re.loop 0 9) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "m")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)