;test regex 5\D{0,3}5\D{0,3}4\D{0,5}2\D{0,3}2\D{0,3}1\D{0,5}5\D{0,3}5\D{0,3}5\D{0,3}5
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "5") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "5") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "4") (re.++ ((_ re.loop 0 5) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "2") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "2") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ ((_ re.loop 0 5) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "5") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "5") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "5") (re.++ ((_ re.loop 0 3) (re.diff re.allchar (re.range "0" "9"))) (str.to_re "5")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)