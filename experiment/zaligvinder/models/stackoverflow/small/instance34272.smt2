;test regex ^TE1310 [a-zA-Z0-9]{8} [a-zA-Z0-9]{16} 0013\.0002\.0000
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "1310") (re.++ (str.to_re " ") (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 16 16) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (str.to_re " ") (re.++ (str.to_re "0013") (re.++ (str.to_re ".") (re.++ (str.to_re "0002") (re.++ (str.to_re ".") (str.to_re "0000"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)