;test regex ((0?(412|414|416|424|426))\d{3}|\d{4})\d{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.++ (re.opt (str.to_re "0")) (re.union (re.union (re.union (re.union (str.to_re "412") (str.to_re "414")) (str.to_re "416")) (str.to_re "424")) (str.to_re "426"))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 7 7) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)