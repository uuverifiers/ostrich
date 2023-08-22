;test regex Last Draw - ([0-9]{1,}) ([0-9]{1,}) ([0-9]{1,})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "L") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "D") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "w") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re " ") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re " ") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)