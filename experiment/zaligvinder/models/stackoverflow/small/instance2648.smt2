;test regex ((aaa*b{0,2})+)|((b{0,2}aaa*)+)
(declare-const X String)
(assert (str.in_re X (re.union (re.+ (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (re.* (str.to_re "a")) ((_ re.loop 0 2) (str.to_re "b")))))) (re.+ (re.++ ((_ re.loop 0 2) (str.to_re "b")) (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.* (str.to_re "a")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)