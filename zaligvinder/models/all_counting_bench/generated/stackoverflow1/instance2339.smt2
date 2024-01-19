;test regex \d{4}_\d{2}.*Monthly Report\.xlsm
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "M") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "l") (re.++ (str.to_re "y") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (re.++ (str.to_re ".") (re.++ (str.to_re "x") (re.++ (str.to_re "l") (re.++ (str.to_re "s") (str.to_re "m")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)