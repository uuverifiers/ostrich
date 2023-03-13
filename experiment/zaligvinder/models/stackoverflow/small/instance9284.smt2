;test regex a = ^(^0{0,2}\d|^0{0,1}\d\d|[0-1]\d\d|2[0-4]\d|25[0-5])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (str.to_re " ")))) (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 0 2) (str.to_re "0")) (re.range "0" "9"))) (re.++ (str.to_re "") (re.++ ((_ re.loop 0 1) (str.to_re "0")) (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (re.range "0" "1") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (str.to_re "25") (re.range "0" "5"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)