;test regex \A\$(.{1,79})\*([0-9A-F]{2})\r\n\Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "$") (re.++ ((_ re.loop 1 79) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "*") (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (str.to_re "Z"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)