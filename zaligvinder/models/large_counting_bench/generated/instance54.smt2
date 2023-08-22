;test regex ^.*SEARCH \/ HTTP\/1\.1\u{0d}\u{0a}Host\u{3a}.{0,251}\u{0d}\u{0a}\u{0d}\u{0a}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "C") (re.++ (str.to_re "H") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "H") (re.++ (str.to_re "T") (re.++ (str.to_re "T") (re.++ (str.to_re "P") (re.++ (str.to_re "/") (re.++ (str.to_re "1") (re.++ (str.to_re ".") (re.++ (str.to_re "1") (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "H") (re.++ (str.to_re "o") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "\u{3a}") (re.++ ((_ re.loop 0 251) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)