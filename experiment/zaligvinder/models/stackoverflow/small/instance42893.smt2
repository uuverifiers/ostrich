;test regex SPECIAL_WORD\s\d{6}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "P") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "I") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "_") (re.++ (str.to_re "W") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "D") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 6 6) (re.range "0" "9")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)