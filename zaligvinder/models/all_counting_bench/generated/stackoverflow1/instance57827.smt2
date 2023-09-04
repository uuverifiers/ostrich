;test regex "(^\\d+?\\.?\\d{0,2})([A-Za-z]+|\\s[A-Za-z]+)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\\") ((_ re.loop 0 2) (str.to_re "d")))))))) (re.++ (re.union (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z")))))) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)