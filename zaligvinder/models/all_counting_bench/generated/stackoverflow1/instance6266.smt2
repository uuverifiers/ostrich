;test regex (\\b\\w+\\b)\\s{1}\\1
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re "\\") (str.to_re "b")))))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 1) (str.to_re "s")) (re.++ (str.to_re "\\") (str.to_re "1")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)