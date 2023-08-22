;test regex ([ \&nbsp\;]{2,200})
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 200) (re.union (str.to_re " ") (re.union (str.to_re "&") (re.union (str.to_re "n") (re.union (str.to_re "b") (re.union (str.to_re "s") (re.union (str.to_re "p") (str.to_re ";"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)