;test regex (AS|NL|MH  etc)XXX(\d{2})XXX([A-Z]*)XXX(\d{4})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "A") (str.to_re "S")) (re.++ (str.to_re "N") (str.to_re "L"))) (re.++ (str.to_re "M") (re.++ (str.to_re "H") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (str.to_re "c")))))))) (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (re.* (re.range "A" "Z")) (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (str.to_re "X") ((_ re.loop 4 4) (re.range "0" "9"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)