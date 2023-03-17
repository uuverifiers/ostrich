;test regex (\\(\\d{4}\\)|\\[ANONYMOUS],)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (str.to_re "\\")))) (re.++ (re.++ (str.to_re "\\") (re.union (str.to_re "A") (re.union (str.to_re "N") (re.union (str.to_re "O") (re.union (str.to_re "N") (re.union (str.to_re "Y") (re.union (str.to_re "M") (re.union (str.to_re "O") (re.union (str.to_re "U") (str.to_re "S")))))))))) (str.to_re ",")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)