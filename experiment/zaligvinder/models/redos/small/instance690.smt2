;test regex ^mlid=(w\d{16})\r\npasswd=(.{16,32})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "m") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ (re.++ (str.to_re "w") ((_ re.loop 16 16) (re.range "0" "9"))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re "w") (re.++ (str.to_re "d") (re.++ (str.to_re "=") ((_ re.loop 16 32) (re.diff re.allchar (str.to_re "\n"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)