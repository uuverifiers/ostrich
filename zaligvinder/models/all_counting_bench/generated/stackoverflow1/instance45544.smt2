;test regex (.*?)(\.|_?)(000\d{0,})(.*)\.jpg
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re ".") (re.opt (str.to_re "_"))) (re.++ (re.++ (str.to_re "000") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9")))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)