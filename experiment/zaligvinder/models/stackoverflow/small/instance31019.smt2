;test regex Romans(\?| |\.|\. |\.\r\n|\r\n)([0-9]{1,3}):([0-9]{1,3})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "?") (str.to_re " ")) (str.to_re ".")) (re.++ (str.to_re ".") (str.to_re " "))) (re.++ (str.to_re ".") (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 1 3) (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)