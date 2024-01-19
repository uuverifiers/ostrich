;test regex 0{0}[1-9][0-9]{10}|0{1}[1-9][0-9]{9}|0{2}[1-9][0-9]{8}|...|0{10}[1-9][0-9]{0}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ ((_ re.loop 0 0) (str.to_re "0")) (re.++ (re.range "1" "9") ((_ re.loop 10 10) (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (str.to_re "0")) (re.++ (re.range "1" "9") ((_ re.loop 9 9) (re.range "0" "9"))))) (re.++ ((_ re.loop 2 2) (str.to_re "0")) (re.++ (re.range "1" "9") ((_ re.loop 8 8) (re.range "0" "9"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ ((_ re.loop 10 10) (str.to_re "0")) (re.++ (re.range "1" "9") ((_ re.loop 0 0) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)