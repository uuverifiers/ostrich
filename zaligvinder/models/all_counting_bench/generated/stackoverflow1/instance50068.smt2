;test regex ([123456789TJQKA]){1}([dsch]?){1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "123456789") (re.union (str.to_re "T") (re.union (str.to_re "J") (re.union (str.to_re "Q") (re.union (str.to_re "K") (str.to_re "A"))))))) ((_ re.loop 1 1) (re.opt (re.union (str.to_re "d") (re.union (str.to_re "s") (re.union (str.to_re "c") (str.to_re "h")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)