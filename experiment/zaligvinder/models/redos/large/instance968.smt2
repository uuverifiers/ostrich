;test regex .*ADCC[B-D]{200,200}.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "A") (re.++ (str.to_re "D") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ ((_ re.loop 200 200) (re.range "B" "D")) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)