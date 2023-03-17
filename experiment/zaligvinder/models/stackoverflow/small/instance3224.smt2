;test regex [a-z]+ [a-z]+ \+[0-9]{1,}\\r\\n[a-z]+
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re " ") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re " ") (re.++ (str.to_re "+") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "\\") (re.++ (str.to_re "r") (re.++ (str.to_re "\\") (re.++ (str.to_re "n") (re.+ (re.range "a" "z"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)