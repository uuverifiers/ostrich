;test regex ^File=D:\\[a-zA-Z]+\\[a-z]+\\([0-9]{4})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "F") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "D") (re.++ (str.to_re ":") (re.++ (str.to_re "\\") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "\\") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re "\\") ((_ re.loop 4 4) (re.range "0" "9")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)