;test regex (a\*)(b)\*{2}(N)\*d
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "a") (str.to_re "*")) (re.++ (str.to_re "b") (re.++ ((_ re.loop 2 2) (str.to_re "*")) (re.++ (str.to_re "N") (re.++ (str.to_re "*") (str.to_re "d"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)