;test regex \(\d{1,2}\)([\w\W]*?)\(\d{1,2}\)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "(") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ")") (re.++ (re.* (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_"))))))) (re.++ (str.to_re "(") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ")")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)