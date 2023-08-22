;test regex [^a-zA-Z0-9 ]|([a-zA-Z]{2,4}[0-9]{1,5}_part[0-9]{1,5})
(declare-const X String)
(assert (str.in_re X (re.union (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re " "))))) (re.++ ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "t") ((_ re.loop 1 5) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)