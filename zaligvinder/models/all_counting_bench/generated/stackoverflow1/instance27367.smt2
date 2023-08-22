;test regex ([\u0370-\u03FF| ]{2,})
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.range "\u{0370}" "\u{03ff}") (re.union (str.to_re "|") (str.to_re " ")))) ((_ re.loop 2 2) (re.union (re.range "\u{0370}" "\u{03ff}") (re.union (str.to_re "|") (str.to_re " ")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)