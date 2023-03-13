;test regex 0{3,10}|[JjYy]{2}0{3,8}|[JjYy]{4}0{3,6}
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 3 10) (str.to_re "0")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "J") (re.union (str.to_re "j") (re.union (str.to_re "Y") (str.to_re "y"))))) ((_ re.loop 3 8) (str.to_re "0")))) (re.++ ((_ re.loop 4 4) (re.union (str.to_re "J") (re.union (str.to_re "j") (re.union (str.to_re "Y") (str.to_re "y"))))) ((_ re.loop 3 6) (str.to_re "0"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)