;test regex (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) (?:Chan)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "C") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (str.to_re "n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)