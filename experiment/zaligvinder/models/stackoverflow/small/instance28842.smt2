;test regex \(?[A-Za-z].+?(BINARY\([0-9]{1,2}\))
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "(")) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "B") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "Y") (re.++ (str.to_re "(") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ")"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)