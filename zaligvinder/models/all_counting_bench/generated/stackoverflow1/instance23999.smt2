;test regex xyz\r\n((\d{3}). (.*)\r\n)+abc
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "x") (re.++ (str.to_re "y") (re.++ (str.to_re "z") (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (re.+ (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))))) (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)