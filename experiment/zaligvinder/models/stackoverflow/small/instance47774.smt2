;test regex "\\D*([2-9]\\d{2})(\\D*)([2-9]\\d{2})(\\D*)(\\d{4})\\D*"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "D")) (re.++ (re.++ (re.range "2" "9") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d")))) (re.++ (re.++ (str.to_re "\\") (re.* (str.to_re "D"))) (re.++ (re.++ (re.range "2" "9") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d")))) (re.++ (re.++ (str.to_re "\\") (re.* (str.to_re "D"))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "D")) (str.to_re "\u{22}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)