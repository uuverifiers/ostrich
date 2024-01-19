;test regex date ([a-z]{3} \d{2}) at (\d{2}) ([PA]M)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "P") (str.to_re "A")) (str.to_re "M"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)