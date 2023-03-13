;test regex @"^(\+|-)?((\d((\.)|\.\d{1,6})?)|(0*?\d\d((\.)|\.\d{1,6})?)|(0*?1[0-7]\d((\.)|\.\d{1,6})?)|(0*?180((\.)|\.0{1,6})?))$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.union (re.union (re.++ (re.range "0" "9") (re.opt (re.union (str.to_re ".") (re.++ (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9")))))) (re.++ (re.* (str.to_re "0")) (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.opt (re.union (str.to_re ".") (re.++ (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))))))))) (re.++ (re.* (str.to_re "0")) (re.++ (str.to_re "1") (re.++ (re.range "0" "7") (re.++ (re.range "0" "9") (re.opt (re.union (str.to_re ".") (re.++ (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9")))))))))) (re.++ (re.* (str.to_re "0")) (re.++ (str.to_re "180") (re.opt (re.union (str.to_re ".") (re.++ (str.to_re ".") ((_ re.loop 1 6) (str.to_re "0"))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)