;test regex 10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172.([1][6-9]|[2][0-9]|[3][0-1])\.[0-9]{1,3}\.[0-9]{1,3}|192.168\.[0-9]{1,3}\.[0-9]{1,3}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "10") (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))))))) (re.++ (str.to_re "172") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.union (re.union (re.++ (str.to_re "1") (re.range "6" "9")) (re.++ (str.to_re "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))))))) (re.++ (str.to_re "192") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "168") (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)