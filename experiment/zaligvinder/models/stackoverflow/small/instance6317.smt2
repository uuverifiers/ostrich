;test regex .+([.][Pp][Dd][Ff]){1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 1) (re.++ (str.to_re ".") (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.++ (re.union (str.to_re "D") (str.to_re "d")) (re.union (str.to_re "F") (str.to_re "f")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)