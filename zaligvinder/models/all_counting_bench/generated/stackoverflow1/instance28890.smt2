;test regex '${1}[insert number here]$2'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 1 1) (str.to_re "")) (re.union (str.to_re "i") (re.union (str.to_re "n") (re.union (str.to_re "s") (re.union (str.to_re "e") (re.union (str.to_re "r") (re.union (str.to_re "t") (re.union (str.to_re " ") (re.union (str.to_re "n") (re.union (str.to_re "u") (re.union (str.to_re "m") (re.union (str.to_re "b") (re.union (str.to_re "e") (re.union (str.to_re "r") (re.union (str.to_re " ") (re.union (str.to_re "h") (re.union (str.to_re "e") (re.union (str.to_re "r") (str.to_re "e")))))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)