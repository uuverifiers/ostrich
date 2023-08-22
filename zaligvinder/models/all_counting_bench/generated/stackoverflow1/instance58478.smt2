;test regex ^(?:XL|L|L?(?:IX|X{1,3}|X{0,3}(?:IX|IV|V|V?I{1,3})))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "X") (str.to_re "L")) (str.to_re "L")) (re.++ (re.opt (str.to_re "L")) (re.union (re.union (re.++ (str.to_re "I") (str.to_re "X")) ((_ re.loop 1 3) (str.to_re "X"))) (re.++ ((_ re.loop 0 3) (str.to_re "X")) (re.union (re.union (re.union (re.++ (str.to_re "I") (str.to_re "X")) (re.++ (str.to_re "I") (str.to_re "V"))) (str.to_re "V")) (re.++ (re.opt (str.to_re "V")) ((_ re.loop 1 3) (str.to_re "I"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)