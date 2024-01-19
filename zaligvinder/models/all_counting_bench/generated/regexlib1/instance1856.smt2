;test regex \A((?:[01]{0,1}\d)|(?:[2][0123])):([012345]\d):([012345]\d)(.\d{1,3})?([Z]|(?:[+-]?(?:[01]{0,1}\d)|(?:[2][0123])):([012345]\d))\Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.union (re.++ ((_ re.loop 0 1) (str.to_re "01")) (re.range "0" "9")) (re.++ (str.to_re "2") (str.to_re "0123"))) (re.++ (str.to_re ":") (re.++ (re.++ (str.to_re "012345") (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ (re.++ (str.to_re "012345") (re.range "0" "9")) (re.++ (re.opt (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 1 3) (re.range "0" "9")))) (re.++ (re.union (str.to_re "Z") (re.++ (re.union (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.++ ((_ re.loop 0 1) (str.to_re "01")) (re.range "0" "9"))) (re.++ (str.to_re "2") (str.to_re "0123"))) (re.++ (str.to_re ":") (re.++ (str.to_re "012345") (re.range "0" "9"))))) (str.to_re "Z")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)