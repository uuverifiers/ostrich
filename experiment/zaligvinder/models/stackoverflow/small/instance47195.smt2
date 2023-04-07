;test regex (\r\n?|\n){2,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.++ (str.to_re "\u{0d}") (re.opt (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))) ((_ re.loop 2 2) (re.union (re.++ (str.to_re "\u{0d}") (re.opt (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)