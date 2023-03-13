;test regex \d{17}|\d{16}\.\d{1}|\d{15}\.\d{2}|\d{14}\.\d{3}|\d{13}\.\d{4}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union ((_ re.loop 17 17) (re.range "0" "9")) (re.++ ((_ re.loop 16 16) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ ((_ re.loop 15 15) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 14 14) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 13 13) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)