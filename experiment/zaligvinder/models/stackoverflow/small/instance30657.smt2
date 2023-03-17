;test regex '([aieou]*[aieou]){2,}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (re.++ (re.* (re.++ (re.* (re.union (str.to_re "a") (re.union (str.to_re "i") (re.union (str.to_re "e") (re.union (str.to_re "o") (str.to_re "u")))))) (re.union (str.to_re "a") (re.union (str.to_re "i") (re.union (str.to_re "e") (re.union (str.to_re "o") (str.to_re "u"))))))) ((_ re.loop 2 2) (re.++ (re.* (re.union (str.to_re "a") (re.union (str.to_re "i") (re.union (str.to_re "e") (re.union (str.to_re "o") (str.to_re "u")))))) (re.union (str.to_re "a") (re.union (str.to_re "i") (re.union (str.to_re "e") (re.union (str.to_re "o") (str.to_re "u")))))))) (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)