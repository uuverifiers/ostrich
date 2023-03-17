;test regex [Ll]ogin.{0,3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "L") (str.to_re "l")) (re.++ (str.to_re "o") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "n") ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)