;test regex [&]{1}token[=]{1}([a-zA-Z0-9-%]*)(%3A(.*?)%3A){1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "&")) (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ ((_ re.loop 1 1) (str.to_re "=")) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re "%")))))) ((_ re.loop 1 1) (re.++ (str.to_re "%") (re.++ (str.to_re "3") (re.++ (str.to_re "A") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "%") (re.++ (str.to_re "3") (str.to_re "A"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)