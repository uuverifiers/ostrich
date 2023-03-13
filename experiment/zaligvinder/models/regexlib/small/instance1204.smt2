;test regex ^(([0]([2|3|4|5|6|8|9|7])))\d{7,8}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "0") (re.union (str.to_re "2") (re.union (str.to_re "|") (re.union (str.to_re "3") (re.union (str.to_re "|") (re.union (str.to_re "4") (re.union (str.to_re "|") (re.union (str.to_re "5") (re.union (str.to_re "|") (re.union (str.to_re "6") (re.union (str.to_re "|") (re.union (str.to_re "8") (re.union (str.to_re "|") (re.union (str.to_re "9") (re.union (str.to_re "|") (str.to_re "7")))))))))))))))) ((_ re.loop 7 8) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)