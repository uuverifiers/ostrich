;test regex (\\w{0,3})(\\d{0,7})(\\w{0,3})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\\") ((_ re.loop 0 3) (str.to_re "w"))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 0 7) (str.to_re "d"))) (re.++ (str.to_re "\\") ((_ re.loop 0 3) (str.to_re "w")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)