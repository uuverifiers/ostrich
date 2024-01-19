;test regex (Target1.{1,100}[\n\r].{1,100}Target2)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "T") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "1") (re.++ ((_ re.loop 1 100) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")) (re.++ ((_ re.loop 1 100) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "T") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (str.to_re "2")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)