;test regex [1-3][0-2][xs0][30Aa][xsu][.,]{6} or ^[1-3][0-2][xs0][30Aa][xsu][.,]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.range "1" "3") (re.++ (re.range "0" "2") (re.++ (re.union (str.to_re "x") (re.union (str.to_re "s") (str.to_re "0"))) (re.++ (re.union (str.to_re "30") (re.union (str.to_re "A") (str.to_re "a"))) (re.++ (re.union (str.to_re "x") (re.union (str.to_re "s") (str.to_re "u"))) (re.++ ((_ re.loop 6 6) (re.union (str.to_re ".") (str.to_re ","))) (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re " ")))))))))) (re.++ (str.to_re "") (re.++ (re.range "1" "3") (re.++ (re.range "0" "2") (re.++ (re.union (str.to_re "x") (re.union (str.to_re "s") (str.to_re "0"))) (re.++ (re.union (str.to_re "30") (re.union (str.to_re "A") (str.to_re "a"))) (re.++ (re.union (str.to_re "x") (re.union (str.to_re "s") (str.to_re "u"))) (re.union (str.to_re ".") (str.to_re ","))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)