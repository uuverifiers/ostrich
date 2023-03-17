;test regex ~(.*)(?:CONTENTS\n.*?\n{3,})(.*)~ms
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "~") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "T") (re.++ (str.to_re "S") (re.++ (str.to_re "\u{0a}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (str.to_re "\u{0a}")) ((_ re.loop 3 3) (str.to_re "\u{0a}"))))))))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "~") (re.++ (str.to_re "m") (str.to_re "s")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)