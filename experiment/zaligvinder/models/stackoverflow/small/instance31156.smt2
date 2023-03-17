;test regex ^[bahsvieyksa]{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 5 5) (re.union (str.to_re "b") (re.union (str.to_re "a") (re.union (str.to_re "h") (re.union (str.to_re "s") (re.union (str.to_re "v") (re.union (str.to_re "i") (re.union (str.to_re "e") (re.union (str.to_re "y") (re.union (str.to_re "k") (re.union (str.to_re "s") (str.to_re "a"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)