;test regex "-?(\\d{1,5}|1\\d{5}|2(?:0\\d{4}|1(?:[0-3]\\d{3}|4(?:[0-6]\\d{2}|7(?:[0-3]\\d|4[0-8])))))"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.opt (str.to_re "-")) (re.++ (re.union (re.union (re.++ (str.to_re "\\") ((_ re.loop 1 5) (str.to_re "d"))) (re.++ (str.to_re "1") (re.++ (str.to_re "\\") ((_ re.loop 5 5) (str.to_re "d"))))) (re.++ (str.to_re "2") (re.union (re.++ (str.to_re "0") (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d")))) (re.++ (str.to_re "1") (re.union (re.++ (re.range "0" "3") (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d")))) (re.++ (str.to_re "4") (re.union (re.++ (re.range "0" "6") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d")))) (re.++ (str.to_re "7") (re.union (re.++ (re.range "0" "3") (re.++ (str.to_re "\\") (str.to_re "d"))) (re.++ (str.to_re "4") (re.range "0" "8"))))))))))) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)