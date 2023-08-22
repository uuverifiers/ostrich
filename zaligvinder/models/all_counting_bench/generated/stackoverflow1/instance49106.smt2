;test regex ^[A-Za-z](?:[^A-Za-z]*[A-Za-z][^A-Za-z]*){5}$|^[_$%](?:[^A-Za-z]*[A-Za-z][^A-Za-z]*){6}$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) ((_ re.loop 5 5) (re.++ (re.* (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (re.range "a" "z")))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.* (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (re.range "a" "z"))))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "_") (re.union (str.to_re "$") (str.to_re "%"))) ((_ re.loop 6 6) (re.++ (re.* (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (re.range "a" "z")))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.* (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (re.range "a" "z"))))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)