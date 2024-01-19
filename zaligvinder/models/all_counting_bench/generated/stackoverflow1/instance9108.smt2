;test regex ^(\/path)(\/?\?{0}|\/?\?{1}.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "h"))))) (re.union (re.++ (re.opt (str.to_re "/")) ((_ re.loop 0 0) (str.to_re "?"))) (re.++ (re.opt (str.to_re "/")) (re.++ ((_ re.loop 1 1) (str.to_re "?")) (re.* (re.diff re.allchar (str.to_re "\n")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)