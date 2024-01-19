;test regex "[-\\d]{2}[\u0600-\u06FF][-\\d]{3}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 2 2) (re.union (str.to_re "-") (re.union (str.to_re "\\") (str.to_re "d")))) (re.++ (re.range "\u{0600}" "\u{06ff}") (re.++ ((_ re.loop 3 3) (re.union (str.to_re "-") (re.union (str.to_re "\\") (str.to_re "d")))) (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)