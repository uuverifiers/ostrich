;test regex [a-zA-Z]_{0,1}+\d+\.png
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.+ ((_ re.loop 0 1) (str.to_re "_"))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)