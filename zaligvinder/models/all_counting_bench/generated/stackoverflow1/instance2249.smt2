;test regex [...]{2,} # min. 2 or more
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.union (str.to_re ".") (re.union (str.to_re ".") (str.to_re ".")))) ((_ re.loop 2 2) (re.union (str.to_re ".") (re.union (str.to_re ".") (str.to_re "."))))) (re.++ (str.to_re " ") (re.++ (str.to_re "#") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re " ") (re.++ (str.to_re "2") (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "e"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)