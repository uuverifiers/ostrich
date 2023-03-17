;test regex "e?(grep){3,7}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.opt (str.to_re "e")) (re.++ ((_ re.loop 3 7) (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "p"))))) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)