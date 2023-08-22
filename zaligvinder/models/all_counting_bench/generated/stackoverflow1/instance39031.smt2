;test regex ^([^\/\r\n]+?)\/(art)\/(.*)\/.*?\(([xX]?[0-9]{6,7}\.[0-9]+)\).*?\/?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "/")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.++ (str.to_re "/") (re.++ (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "t"))) (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "(") (re.++ (re.++ (re.opt (re.union (str.to_re "x") (str.to_re "X"))) (re.++ ((_ re.loop 6 7) (re.range "0" "9")) (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (str.to_re ")") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.opt (str.to_re "/")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)