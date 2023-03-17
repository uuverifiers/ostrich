;test regex (([CN]{2})($sequence)([CN]{2}))
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "C") (str.to_re "N"))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "q") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "c") (str.to_re "e"))))))))) ((_ re.loop 2 2) (re.union (str.to_re "C") (str.to_re "N")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)