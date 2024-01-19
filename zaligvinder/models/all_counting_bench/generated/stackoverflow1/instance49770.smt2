;test regex (.+?)( PIAZZALE | SS)(.+?)([0-9]{5})
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re " ") (re.++ (str.to_re "P") (re.++ (str.to_re "I") (re.++ (str.to_re "A") (re.++ (str.to_re "Z") (re.++ (str.to_re "Z") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (str.to_re " ")))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "S") (str.to_re "S")))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 5 5) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)