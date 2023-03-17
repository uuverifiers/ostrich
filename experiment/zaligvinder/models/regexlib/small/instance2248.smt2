;test regex    							 (?:(?:1[^0-6]|[2468][^048]|[3579][^26])00)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.++ (str.to_re "1") (re.diff re.allchar (re.range "0" "6"))) (re.++ (str.to_re "2468") (re.diff re.allchar (str.to_re "048")))) (re.++ (str.to_re "3579") (re.diff re.allchar (str.to_re "26")))) (str.to_re "00"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)