;test regex [A-Z0-9]{11}<<[A-Z0-9]{7}<[A-Z0-9]{7}<{7}[A-Z0-9]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 11 11) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "<") (re.++ (str.to_re "<") (re.++ ((_ re.loop 7 7) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re "<") (re.++ ((_ re.loop 7 7) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ ((_ re.loop 7 7) (str.to_re "<")) (re.union (re.range "A" "Z") (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)