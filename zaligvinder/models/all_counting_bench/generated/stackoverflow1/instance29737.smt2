;test regex (^[.*]{1,50}$)/gm
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") ((_ re.loop 1 50) (re.union (str.to_re ".") (str.to_re "*")))) (str.to_re "")) (re.++ (str.to_re "/") (re.++ (str.to_re "g") (str.to_re "m"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)