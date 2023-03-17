;test regex ^(it|en|de|es|fr|ru)[a-zA-Z-;]{2,5}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "i") (str.to_re "t")) (re.++ (str.to_re "e") (str.to_re "n"))) (re.++ (str.to_re "d") (str.to_re "e"))) (re.++ (str.to_re "e") (str.to_re "s"))) (re.++ (str.to_re "f") (str.to_re "r"))) (re.++ (str.to_re "r") (str.to_re "u"))) ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "-") (str.to_re ";")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)