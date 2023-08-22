;test regex (AAAA\n|BBBB\n)([^\n]*\n){3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "A") (re.++ (str.to_re "A") (re.++ (str.to_re "A") (str.to_re "\u{0a}"))))) (re.++ (str.to_re "B") (re.++ (str.to_re "B") (re.++ (str.to_re "B") (re.++ (str.to_re "B") (str.to_re "\u{0a}")))))) ((_ re.loop 3 3) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)