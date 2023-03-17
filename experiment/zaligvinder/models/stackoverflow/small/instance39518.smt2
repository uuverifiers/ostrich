;test regex <tag>[^&<]{6}</tag>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re ">") (re.++ ((_ re.loop 6 6) (re.inter (re.diff re.allchar (str.to_re "&")) (re.diff re.allchar (str.to_re "<")))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (str.to_re ">"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)