;test regex \d{4}YEAR\d{1,2}MONTH\d{1,2}DATE
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "Y") (re.++ (str.to_re "E") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "M") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ (str.to_re "T") (re.++ (str.to_re "H") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "D") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (str.to_re "E"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)