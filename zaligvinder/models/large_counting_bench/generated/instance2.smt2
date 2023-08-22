;test regex ^.* BODY\.PEEK\[[^\]]{1024}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ (str.to_re "B") (re.++ (str.to_re "O") (re.++ (str.to_re "D") (re.++ (str.to_re "Y") (re.++ (str.to_re ".") (re.++ (str.to_re "P") (re.++ (str.to_re "E") (re.++ (str.to_re "E") (re.++ (str.to_re "K") (re.++ (str.to_re "[") ((_ re.loop 1024 1024) (re.diff re.allchar (str.to_re "]"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)