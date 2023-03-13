;test regex (((\(?)((\+|00)31|0)(\)?))([1-9])((\d{8}|\s\d{2}(\s\d{3}){2})|\-\d{8}))|((\+|00)(.*))
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (re.opt (str.to_re "(")) (re.++ (re.union (re.++ (re.union (str.to_re "+") (str.to_re "00")) (str.to_re "31")) (str.to_re "0")) (re.opt (str.to_re ")")))) (re.++ (re.range "1" "9") (re.union (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 3 3) (re.range "0" "9"))))))) (re.++ (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")))))) (re.++ (re.union (str.to_re "+") (str.to_re "00")) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)