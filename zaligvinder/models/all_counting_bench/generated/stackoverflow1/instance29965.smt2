;test regex s/\R{2,}/\n\n/g;
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.++ (re.* (str.to_re "R")) ((_ re.loop 2 2) (str.to_re "R"))) (re.++ (str.to_re "/") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (str.to_re ";")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)