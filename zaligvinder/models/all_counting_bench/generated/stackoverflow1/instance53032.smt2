;test regex A[A-Z,0-9]{5}[0-9]{3} T[0-9]{13} S[0-9]{5}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.union (str.to_re ",") (re.range "0" "9")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "T") (re.++ ((_ re.loop 13 13) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "S") ((_ re.loop 5 5) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)