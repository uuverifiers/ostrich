;test regex PROJECT_NUMBER.([ ]{2,}=.*)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "P") (re.++ (str.to_re "R") (re.++ (str.to_re "O") (re.++ (str.to_re "J") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re "_") (re.++ (str.to_re "N") (re.++ (str.to_re "U") (re.++ (str.to_re "M") (re.++ (str.to_re "B") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.++ (re.* (str.to_re " ")) ((_ re.loop 2 2) (str.to_re " "))) (re.++ (str.to_re "=") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)