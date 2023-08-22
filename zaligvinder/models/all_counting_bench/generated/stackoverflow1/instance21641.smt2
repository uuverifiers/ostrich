;test regex \\d+ ?\\w{0,9} ?\\d+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 0 9) (str.to_re "w")) (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "\\") (re.+ (str.to_re "d")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)