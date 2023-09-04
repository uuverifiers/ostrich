;test regex href=(/a/bar/app\.[a-f0-9]{64}\.css)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re "/") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (str.to_re ".") (re.++ ((_ re.loop 64 64) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "s")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)