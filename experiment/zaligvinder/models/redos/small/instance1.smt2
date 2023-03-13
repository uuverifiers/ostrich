;test regex \D{0,2}[0]{0,3}[1]{0,1}\D{0,2}([2-9])(\d{2})\D{0,2}(\d{3})\D{0,2}(\d{3})\D{0,2}(\d{1})\D{0,2}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 0 3) (str.to_re "0")) (re.++ ((_ re.loop 0 1) (str.to_re "1")) (re.++ ((_ re.loop 0 2) (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.range "2" "9") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 0 2) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 0 2) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 0 2) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 0 2) (re.diff re.allchar (re.range "0" "9")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)