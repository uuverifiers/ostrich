;test regex [^1]1{3}$|[^2]2{3}$|[^3]3{3}$|...
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.++ (re.diff re.allchar (str.to_re "1")) ((_ re.loop 3 3) (str.to_re "1"))) (str.to_re "")) (re.++ (re.++ (re.diff re.allchar (str.to_re "2")) ((_ re.loop 3 3) (str.to_re "2"))) (str.to_re ""))) (re.++ (re.++ (re.diff re.allchar (str.to_re "3")) ((_ re.loop 3 3) (str.to_re "3"))) (str.to_re ""))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)