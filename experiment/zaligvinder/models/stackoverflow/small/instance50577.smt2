;test regex Insurance(.{25}).*?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ ((_ re.loop 25 25) (re.diff re.allchar (str.to_re "\n"))) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)