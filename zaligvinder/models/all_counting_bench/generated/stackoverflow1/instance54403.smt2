;test regex (HYPERLINK "\"{2})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "H") (re.++ (str.to_re "Y") (re.++ (str.to_re "P") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "K") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") ((_ re.loop 2 2) (str.to_re "\u{22}")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)