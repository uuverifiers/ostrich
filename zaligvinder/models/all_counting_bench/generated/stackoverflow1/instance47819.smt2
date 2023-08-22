;test regex foo{1,3} acb[1-2] a foo bar bar(qwer|qwyr)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ ((_ re.loop 1 3) (str.to_re "o")) (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "b") (re.++ (re.range "1" "2") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.union (re.++ (str.to_re "q") (re.++ (str.to_re "w") (re.++ (str.to_re "e") (str.to_re "r")))) (re.++ (str.to_re "q") (re.++ (str.to_re "w") (re.++ (str.to_re "y") (str.to_re "r")))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)