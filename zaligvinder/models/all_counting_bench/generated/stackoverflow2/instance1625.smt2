;test regex s/(^|\n)([^\n]{60})\n/$1$2/g
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.union (str.to_re "") (str.to_re "\u{0a}")) (re.++ ((_ re.loop 60 60) (re.diff re.allchar (str.to_re "\u{0a}"))) (re.++ (str.to_re "\u{0a}") (str.to_re "/")))))) (re.++ (str.to_re "") (str.to_re "1"))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (str.to_re "/") (str.to_re "g")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)