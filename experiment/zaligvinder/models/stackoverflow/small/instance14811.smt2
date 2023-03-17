;test regex (\\+\\d{12}|\\d{11}|\\+91-\\d{10,12}|\\+\\d{2}-\\d{3}-\\d{7})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.+ (str.to_re "\\")) (re.++ (str.to_re "\\") ((_ re.loop 12 12) (str.to_re "d")))) (re.++ (str.to_re "\\") ((_ re.loop 11 11) (str.to_re "d")))) (re.++ (re.+ (str.to_re "\\")) (re.++ (str.to_re "91") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") ((_ re.loop 10 12) (str.to_re "d"))))))) (re.++ (re.+ (str.to_re "\\")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (str.to_re "-") (re.++ (str.to_re "\\") ((_ re.loop 7 7) (str.to_re "d")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)