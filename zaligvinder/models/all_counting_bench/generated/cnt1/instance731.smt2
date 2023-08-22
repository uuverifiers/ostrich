;test regex [\u{20}\u{20}]\u{20}.{6}(?:RSA1|RSA2|DSS1|DSS2).{20}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "\u{20}") (str.to_re "\u{20}")) (re.++ (str.to_re "\u{20}") (re.++ ((_ re.loop 6 6) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "R") (re.++ (str.to_re "S") (re.++ (str.to_re "A") (str.to_re "1")))) (re.++ (str.to_re "R") (re.++ (str.to_re "S") (re.++ (str.to_re "A") (str.to_re "2"))))) (re.++ (str.to_re "D") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (str.to_re "1"))))) (re.++ (str.to_re "D") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (str.to_re "2"))))) ((_ re.loop 20 20) (re.diff re.allchar (str.to_re "\n")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)