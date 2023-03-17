;test regex from(.|\n){1,}(where)(.|\n){1,}select
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "f") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (re.++ (re.* (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}"))) ((_ re.loop 1 1) (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}")))) (re.++ (re.++ (str.to_re "w") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (str.to_re "e"))))) (re.++ (re.++ (re.* (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}"))) ((_ re.loop 1 1) (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}")))) (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (str.to_re "t")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)