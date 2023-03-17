;test regex [1-6]{6}|([1-6]|\*){1,6}[^123456]
(declare-const X String)
(assert (str.in_re X (re.union ((_ re.loop 6 6) (re.range "1" "6")) (re.++ ((_ re.loop 1 6) (re.union (re.range "1" "6") (str.to_re "*"))) (re.diff re.allchar (str.to_re "123456"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)