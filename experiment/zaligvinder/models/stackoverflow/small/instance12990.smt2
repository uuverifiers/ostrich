;test regex ((YOUR SENTENCE HERE)|(YOUR OTHER SENTENCE)){1}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 1 1) (re.union (re.++ (str.to_re "Y") (re.++ (str.to_re "O") (re.++ (str.to_re "U") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "C") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (str.to_re "E")))))))))))))))))) (re.++ (str.to_re "Y") (re.++ (str.to_re "O") (re.++ (str.to_re "U") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "O") (re.++ (str.to_re "T") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "C") (str.to_re "E")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)