;test regex ^\$2[a-z]?\$([0-9]+)\$(.{22})(.{31})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "$") (re.++ (str.to_re "2") (re.++ (re.opt (re.range "a" "z")) (re.++ (str.to_re "$") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "$") (re.++ ((_ re.loop 22 22) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 31 31) (re.diff re.allchar (str.to_re "\n"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)