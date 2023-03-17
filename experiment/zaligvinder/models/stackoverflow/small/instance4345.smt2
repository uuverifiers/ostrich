;test regex $ echo 12345aaa6789aaa01234 | grep -E "(^|[^0-9])[0-9]{3,5}([^0-9]|$)"
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "12345") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "6789") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "01234") (str.to_re " "))))))))))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.union (str.to_re "") (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (re.++ (re.union (re.diff re.allchar (re.range "0" "9")) (str.to_re "")) (str.to_re "\u{22}")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)