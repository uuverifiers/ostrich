;test regex [deleted]{3,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "d") (re.union (str.to_re "e") (re.union (str.to_re "l") (re.union (str.to_re "e") (re.union (str.to_re "t") (re.union (str.to_re "e") (str.to_re "d")))))))) ((_ re.loop 3 3) (re.union (str.to_re "d") (re.union (str.to_re "e") (re.union (str.to_re "l") (re.union (str.to_re "e") (re.union (str.to_re "t") (re.union (str.to_re "e") (str.to_re "d")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)