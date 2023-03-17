;test regex ^Ltd[.'s]{0,2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "L") (re.++ (str.to_re "t") (re.++ (str.to_re "d") ((_ re.loop 0 2) (re.union (str.to_re ".") (re.union (str.to_re "\u{27}") (str.to_re "s")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)