;test regex select '354902050487064_Gismo3' ~* '\\d{15}_\\w+'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "354902050487064") (re.++ (str.to_re "_") (re.++ (str.to_re "G") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "3") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (re.* (str.to_re "~")) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 15 15) (str.to_re "d")) (re.++ (str.to_re "_") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (str.to_re "\u{27}")))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)