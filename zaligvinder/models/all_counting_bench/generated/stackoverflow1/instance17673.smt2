;test regex P(\d+[YMDW]){0,4}T(\d+[HMS]){0,3}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "P") (re.++ ((_ re.loop 0 4) (re.++ (re.+ (re.range "0" "9")) (re.union (str.to_re "Y") (re.union (str.to_re "M") (re.union (str.to_re "D") (str.to_re "W")))))) (re.++ (str.to_re "T") ((_ re.loop 0 3) (re.++ (re.+ (re.range "0" "9")) (re.union (str.to_re "H") (re.union (str.to_re "M") (str.to_re "S"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)