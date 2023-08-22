;test regex .*GDIIJFHE[AB]+[C-J]{52,52}([AB].*|B+.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "G") (re.++ (str.to_re "D") (re.++ (str.to_re "I") (re.++ (str.to_re "I") (re.++ (str.to_re "J") (re.++ (str.to_re "F") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (re.+ (re.union (str.to_re "A") (str.to_re "B"))) (re.++ ((_ re.loop 52 52) (re.range "C" "J")) (re.union (re.++ (re.union (str.to_re "A") (str.to_re "B")) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.+ (str.to_re "B")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)