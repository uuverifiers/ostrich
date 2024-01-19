;test regex String SPANISH_NUMBER_REGEX = "[679]\\d{8}";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "P") (re.++ (str.to_re "A") (re.++ (str.to_re "N") (re.++ (str.to_re "I") (re.++ (str.to_re "S") (re.++ (str.to_re "H") (re.++ (str.to_re "_") (re.++ (str.to_re "N") (re.++ (str.to_re "U") (re.++ (str.to_re "M") (re.++ (str.to_re "B") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "_") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "679") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 8 8) (str.to_re "d")) (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)