;test regex IMG[0-9]{8}_?[a-zA-Z]?(?:[0-9]{2})?\.JPG
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re "M") (re.++ (str.to_re "G") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (re.opt (str.to_re "_")) (re.++ (re.opt (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re ".") (re.++ (str.to_re "J") (re.++ (str.to_re "P") (str.to_re "G")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)