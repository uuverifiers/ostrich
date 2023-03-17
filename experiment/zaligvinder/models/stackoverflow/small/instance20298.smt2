;test regex (2008\R(?:.+\R){4}).+\R.+\R
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "2008") (re.++ (str.to_re "R") ((_ re.loop 4 4) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "R"))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "R") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "R")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)