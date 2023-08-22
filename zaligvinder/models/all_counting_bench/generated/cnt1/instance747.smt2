;test regex  PROCESS(.{32})WORKING\n
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re " ") (re.++ (str.to_re "P") (re.++ (str.to_re "R") (re.++ (str.to_re "O") (re.++ (str.to_re "C") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ ((_ re.loop 32 32) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "W") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "K") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "G") (str.to_re "\u{0a}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)