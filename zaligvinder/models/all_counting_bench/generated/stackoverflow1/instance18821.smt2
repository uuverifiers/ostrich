;test regex STID *= *[A-Z]{4} *STNM *= [0-9]* *TIME *= *[0-9]*/[0-9]*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "=") (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "N") (re.++ (str.to_re "M") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (re.* (re.range "0" "9")) (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "T") (re.++ (str.to_re "I") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "=") (re.++ (re.* (str.to_re " ")) (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re "/") (re.* (re.range "0" "9")))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)