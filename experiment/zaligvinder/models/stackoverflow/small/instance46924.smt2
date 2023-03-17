;test regex regexPattern="\\w{6}(AAAAA|BBBBB|CCCCC)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "P") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 6 6) (str.to_re "w")) (re.++ (re.union (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "A") (re.++ (str.to_re "A") (re.++ (str.to_re "A") (str.to_re "A"))))) (re.++ (str.to_re "B") (re.++ (str.to_re "B") (re.++ (str.to_re "B") (re.++ (str.to_re "B") (str.to_re "B")))))) (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (str.to_re "C")))))) (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)