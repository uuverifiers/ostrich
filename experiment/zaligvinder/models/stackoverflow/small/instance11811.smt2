;test regex ereg('^(A|Q)([0-9]{4})',$part,$pieces)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "") (re.++ (re.union (str.to_re "A") (str.to_re "Q")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{27}"))))) (str.to_re ",")) (re.++ (str.to_re "") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "t")))))) (str.to_re ",")) (re.++ (str.to_re "") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (str.to_re "s"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)