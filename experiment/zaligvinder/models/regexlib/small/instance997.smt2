;test regex \A-?(\d{4,})-(\d{2})-(\d{2})([Z]|(?:[+-]?(?:[01]\d)|(?:[2][0123])):(?:[012345]\d))\Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.opt (str.to_re "-")) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "Z") (re.++ (re.union (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.++ (str.to_re "01") (re.range "0" "9"))) (re.++ (str.to_re "2") (str.to_re "0123"))) (re.++ (str.to_re ":") (re.++ (str.to_re "012345") (re.range "0" "9"))))) (str.to_re "Z")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)