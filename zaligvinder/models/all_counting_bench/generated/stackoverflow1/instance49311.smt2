;test regex ^.{3}Y[0-9]{1}.{5}[a-zA-Z]{1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "Y") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)