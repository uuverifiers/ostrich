;test regex \( 15^{2} = \( \sqrt{225} \) \)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "(") (re.++ (str.to_re " ") (str.to_re "15"))) (re.++ ((_ re.loop 2 2) (str.to_re "")) (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (str.to_re " ") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "q") (re.++ (str.to_re "r") (re.++ ((_ re.loop 225 225) (str.to_re "t")) (re.++ (str.to_re " ") (re.++ (str.to_re ")") (re.++ (str.to_re " ") (str.to_re ")")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)