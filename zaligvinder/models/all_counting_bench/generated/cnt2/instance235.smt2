;test regex SET_(SENDFROM|MAILHOST)\u{20}\u{20}[^\u{20}]{256}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "T") (re.++ (str.to_re "_") (re.++ (re.union (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "D") (re.++ (str.to_re "F") (re.++ (str.to_re "R") (re.++ (str.to_re "O") (str.to_re "M")))))))) (re.++ (str.to_re "M") (re.++ (str.to_re "A") (re.++ (str.to_re "I") (re.++ (str.to_re "L") (re.++ (str.to_re "H") (re.++ (str.to_re "O") (re.++ (str.to_re "S") (str.to_re "T"))))))))) (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") ((_ re.loop 256 256) (re.diff re.allchar (str.to_re "\u{20}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)