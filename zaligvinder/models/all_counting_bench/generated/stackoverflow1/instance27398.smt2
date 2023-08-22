;test regex \AVCS(Trades|Positions)_[0-9]{8}_OMEGA\.csv\Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "V") (re.++ (str.to_re "C") (re.++ (str.to_re "S") (re.++ (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "s")))))) (re.++ (str.to_re "P") (re.++ (str.to_re "o") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (str.to_re "s")))))))))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "O") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "A") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "s") (re.++ (str.to_re "v") (str.to_re "Z"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)