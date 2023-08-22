;test regex ^ch[1-8]{1,1}l[1-8]{1,1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ ((_ re.loop 1 1) (re.range "1" "8")) (re.++ (str.to_re "l") ((_ re.loop 1 1) (re.range "1" "8"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)