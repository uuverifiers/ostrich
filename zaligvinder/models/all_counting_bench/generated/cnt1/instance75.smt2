;test regex ^<Buffer (?:78 ){50}\.\.\. >$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "<") (re.++ (str.to_re "B") (re.++ (str.to_re "u") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ ((_ re.loop 50 50) (re.++ (str.to_re "78") (str.to_re " "))) (re.++ (str.to_re ".") (re.++ (str.to_re ".") (re.++ (str.to_re ".") (re.++ (str.to_re " ") (str.to_re ">"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)