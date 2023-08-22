;test regex products("{1,3}{4,5}a{6,7}");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (re.++ (str.to_re "u") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "s") (re.++ (re.++ ((_ re.loop 4 5) ((_ re.loop 1 3) (str.to_re "\u{22}"))) (re.++ ((_ re.loop 6 7) (str.to_re "a")) (str.to_re "\u{22}"))) (str.to_re ";"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)