;test regex ^(?:eval|local-test_logging\.js|[a-f0-9]{40}\.js)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (str.to_re "l")))) (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "-") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "_") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "g") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re ".") (re.++ (str.to_re "j") (str.to_re "s")))))))))))))))))))))) (re.++ ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ".") (re.++ (str.to_re "j") (str.to_re "s"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)