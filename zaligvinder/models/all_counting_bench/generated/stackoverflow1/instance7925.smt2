;test regex \d+\.((0?\d)|(1\d)|(2[0-3]))(:[0-5]\d){2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.union (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "3"))) ((_ re.loop 2 2) (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)