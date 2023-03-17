;test regex (a)(w)(K)(J){3}{8}(W){3}(i)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "w") (re.++ (str.to_re "K") (re.++ ((_ re.loop 8 8) ((_ re.loop 3 3) (str.to_re "J"))) (re.++ ((_ re.loop 3 3) (str.to_re "W")) (str.to_re "i"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)