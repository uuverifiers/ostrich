;test regex ([10]{2})(0{1})([11]{2})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (str.to_re "10")) (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 2 2) (str.to_re "11"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)