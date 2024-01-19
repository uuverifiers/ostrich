;test regex (a[aeiou]{2}|i[aeiou]{2}|i[aeiou]{2}|o[aeiou]{2}|u[aeiou]{2})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ (str.to_re "a") ((_ re.loop 2 2) (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u"))))))) (re.++ (str.to_re "i") ((_ re.loop 2 2) (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u")))))))) (re.++ (str.to_re "i") ((_ re.loop 2 2) (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u")))))))) (re.++ (str.to_re "o") ((_ re.loop 2 2) (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u")))))))) (re.++ (str.to_re "u") ((_ re.loop 2 2) (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)