;test regex a[^b]{1000}b[^c]{1000}c[^d]{1000}d
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ ((_ re.loop 1000 1000) (re.diff re.allchar (str.to_re "b"))) (re.++ (str.to_re "b") (re.++ ((_ re.loop 1000 1000) (re.diff re.allchar (str.to_re "c"))) (re.++ (str.to_re "c") (re.++ ((_ re.loop 1000 1000) (re.diff re.allchar (str.to_re "d"))) (str.to_re "d")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)