;test regex foo 1\.(2\.([4-9]|\d{2,})|([3-9]|\d{2,})\.\d+)|([2-9]|\d{2,})\.\d+\.\d+
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (re.++ (str.to_re ".") (re.union (re.++ (str.to_re "2") (re.++ (str.to_re ".") (re.union (re.range "4" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (re.union (re.range "3" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))))) (re.++ (re.union (re.range "2" "9") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)