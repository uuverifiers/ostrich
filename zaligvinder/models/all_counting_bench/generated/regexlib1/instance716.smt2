;test regex (^(09|9)[1][1-9]\\d{7}$)|(^(09|9)[3][12456]\\d{7}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "09") (str.to_re "9")) (re.++ (str.to_re "1") (re.++ (re.range "1" "9") (re.++ (str.to_re "\\") ((_ re.loop 7 7) (str.to_re "d"))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "09") (str.to_re "9")) (re.++ (str.to_re "3") (re.++ (str.to_re "12456") (re.++ (str.to_re "\\") ((_ re.loop 7 7) (str.to_re "d"))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)