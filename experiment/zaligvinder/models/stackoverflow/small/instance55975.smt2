;test regex cat.{1,12}mouse
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ ((_ re.loop 1 12) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (str.to_re "e")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)