;test regex /(<XX>){1}([^#]*)(<\/XX>){1}/ig
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "<") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (str.to_re ">"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "#"))) (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (str.to_re ">")))))) (re.++ (str.to_re "/") (re.++ (str.to_re "i") (str.to_re "g")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)