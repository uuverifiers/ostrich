;test regex (\\(?:b|t|n|f|r|\"|\\)|\\(?:(?:[0-2][0-9]{1,2}|3[0-6][0-9]|37[0-7]|[0-9]{1,2}))|\\(?:u(?:[0-9a-fA-F]{4})))
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "\\") (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "b") (str.to_re "t")) (str.to_re "n")) (str.to_re "f")) (str.to_re "r")) (str.to_re "\u{22}")) (str.to_re "\\"))) (re.++ (str.to_re "\\") (re.union (re.union (re.union (re.++ (re.range "0" "2") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.++ (re.range "0" "6") (re.range "0" "9")))) (re.++ (str.to_re "37") (re.range "0" "7"))) ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "u") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)